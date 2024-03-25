import UIKit
import SwiftUI
import MapKit


final class RouteDetailedController: UIViewController, MKMapViewDelegate {
		
		private let route: RouteDetailedUIModel
		
		private let mapView: MKMapView = {
				let control = MKMapView()
				control.layer.cornerRadius = 15
				control.clipsToBounds = false
				control.showsBuildings = true
				control.isZoomEnabled = false
				control.isRotateEnabled = false
				control.isScrollEnabled = false
				control.isUserInteractionEnabled = false
				return control
		}()
		private let titleLabel: UILabel = UILabel()
		private let authorLabel:  UILabel = UILabel()
		private let descriptionLabel: UILabel = UILabel()
		private let beginButton: UIButton = {
				let button = UIButton(type: .system)
				button.layer.cornerRadius = 15
				button.backgroundColor = .systemOrange
				button.tintColor = .white
				button.titleLabel?.font = .boldSystemFont(ofSize: 20)
				button.setTitle("Begin walking", for: .normal)
				return button
		}()
		
		init(route: RouteUIModel) {
				self.route = RouteClient().getFullModel(route: route)
				super.init(nibName: nil, bundle: nil)
		}
		
		required init?(coder: NSCoder) {
				fatalError("init(coder:) has not been implemented")
		}
		
		override func viewDidLoad() {
				super.viewDidLoad()
				view.backgroundColor = .white
				self.tabBarController?.tabBar.isHidden = true
				configureUI()
				drawRoute(route: route.path)
		}
		
		private func configureUI() {
				
				mapView.delegate = self
				let location = CLLocationCoordinate2D(latitude: 55.756, longitude: 37.617)
				let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
				let region = MKCoordinateRegion(center: location, span: span)
				mapView.setRegion(region, animated: true)
				

				let info = UIHostingController(rootView: InfoCard(route: route)).view ?? UIView()
				
				view.addSubview(mapView)
				view.addSubview(info)
				view.addSubview(beginButton)

				beginButton.addTarget(self, action: #selector(buttonTappeed), for: .touchUpInside)
				
				mapView.translatesAutoresizingMaskIntoConstraints = false
				info.translatesAutoresizingMaskIntoConstraints = false
				beginButton.translatesAutoresizingMaskIntoConstraints = false
				
				NSLayoutConstraint.activate([
						mapView.heightAnchor.constraint(equalToConstant: 450),
						mapView.topAnchor.constraint(equalTo: view.topAnchor),
						mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
						mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
						info.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 20),
						info.bottomAnchor.constraint(equalTo: beginButton.topAnchor, constant: 20),
						info.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
						beginButton.heightAnchor.constraint(equalToConstant: 40),
						beginButton.widthAnchor.constraint(equalToConstant: 200),
						beginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
						beginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
				])
		}
		
		private func drawRoute(route: [Point]) {
				let routecord = route.map { point in
						return CLLocationCoordinate2D(latitude: point.latitide, longitude: point.longitude)
				}
				DispatchQueue.main.async {
						let routeOverlay = MKPolyline(coordinates: routecord, count: routecord.count)
						self.mapView.addOverlay(routeOverlay, level: .aboveRoads)
						self.mapView.setVisibleMapRect(
								routeOverlay.boundingMapRect,
								edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50),
								animated: true)
				}
		}
		
		@objc
		private func buttonTappeed(_ sender: UIButton) {
				navigationController?.pushViewController(WalkRouteController(route: self.route), animated: true)
		}
		
		func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
				let renderer = MKPolylineRenderer(overlay: overlay)
				renderer.lineWidth = 5
				renderer.strokeColor = .green
				renderer.lineCap = .round
				return renderer
		}
		
}

struct InfoCard: View {
		private var route: RouteDetailedUIModel
		init(route: RouteDetailedUIModel) {
				self.route = route
		}
		
		var body: some View {
				VStack(alignment: .leading) {
						Text(route.minimodel.title)
								.font(.headline)
						Text(route.minimodel.author)
								.font(.subheadline)
						Text(route.description)
								.font(.body)
						HStack(spacing: 6) {
								Text("\(route.minimodel.distance, specifier: "%.2f")km")
										.font(.caption)
										.padding(6)
										.background(.tertiary)
										.cornerRadius(10)
								Text("\(route.minimodel.duration, specifier: "%.1f")min")
										.font(.caption)
										.padding(6)
										.background(.tertiary)
										.cornerRadius(10)
								Label("\(route.minimodel.rating, specifier: "%.1f")", systemImage: "star.fill")
										.font(.caption)
										.padding(6)
										.background(.tertiary)
										.cornerRadius(10)
						}
						if route.minimodel.pointsOfInterest.count > 0 {
								Spacer()
										.frame(height: 6)
								HStack(spacing: 6) {
										Text(route.minimodel.pointsOfInterest[0])
												.font(.caption)
												.padding(6)
												.background(.blue.opacity(0.3))
												.cornerRadius(10)
										if route.minimodel.pointsOfInterest.count > 1 {
												Text(route.minimodel.pointsOfInterest[1])
														.font(.caption)
														.padding(6)
														.background(.blue.opacity(0.3))
														.cornerRadius(10)
												if route.minimodel.pointsOfInterest.count > 2 {
														Text(route.minimodel.pointsOfInterest[2])
																.font(.caption)
																.padding(6)
																.background(.blue.opacity(0.3))
																.cornerRadius(10)
												}
										}
								}
						}
				}
		}
}
