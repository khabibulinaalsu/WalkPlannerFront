import UIKit
import MapKit
import CoreLocation


final class WalkRouteController: UIViewController {
		
		private let route: RouteDetailedUIModel
		
		private let mapView: MKMapView = {
				let control = MKMapView()
				control.layer.masksToBounds = true
				control.layer.cornerRadius = 15
				control.clipsToBounds = false
				control.showsScale = true
				control.showsCompass = true
				control.showsTraffic = true
				control.showsBuildings = true
				control.showsUserLocation = true
				return control
		}()
		
		private let locationManager: CLLocationManager = {
				let manager = CLLocationManager()
				return manager
		}()
		
		private let finishButton: UIButton = {
				let button = UIButton(type: .system)
				button.layer.cornerRadius = 15
				button.backgroundColor = .systemOrange
				button.tintColor = .white
				button.titleLabel?.font = .boldSystemFont(ofSize: 20)
				button.setTitle("Finish walking", for: .normal)
				button.translatesAutoresizingMaskIntoConstraints = false
				return button
		}()
		
		init(route: RouteDetailedUIModel) {
				self.route = route
				super.init(nibName: nil, bundle: nil)
		}
		
		required init?(coder: NSCoder) {
				fatalError("init(coder:) has not been implemented")
		}
		
		override func viewWillAppear(_ animated: Bool) {
				startMap()
		}
		
		override func viewDidLoad() {
				super.viewDidLoad()
				view.backgroundColor = .white
				configureMap()
				configureButton()
		}
		
		private func startMap() {
				self.locationManager.requestWhenInUseAuthorization()
				
				DispatchQueue.global().async { [weak self] in
						if CLLocationManager.locationServicesEnabled() {
								self?.locationManager.desiredAccuracy = kCLLocationAccuracyBest
						}
				}
		}
		
		private func configureMap() {
				
				view.addSubview(self.mapView)
				
				self.mapView.frame = view.frame
				self.mapView.delegate = self
				
				self.locationManager.delegate = self
				self.locationManager.requestLocation()
				self.locationManager.startUpdatingLocation()
		}
		
		private func configureButton() {
				self.mapView.addSubview(finishButton)
				finishButton.addTarget(self, action: #selector(buttonTappeed), for: .touchUpInside)
				NSLayoutConstraint.activate([
						finishButton.centerXAnchor.constraint(equalTo: self.mapView.centerXAnchor),
						finishButton.heightAnchor.constraint(equalToConstant: 40),
						finishButton.widthAnchor.constraint(equalToConstant: 200),
						finishButton.bottomAnchor.constraint(equalTo: self.mapView.bottomAnchor, constant: -100)
				])
		}
		
		@objc
		private func buttonTappeed(_ sender: UIButton) {
				self.locationManager.stopUpdatingLocation()
				navigationController?.pushViewController(RateViewController(route: self.route), animated: true)
		}
		
}

extension WalkRouteController: MKMapViewDelegate, CLLocationManagerDelegate {
		func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
				
				let userlocation = locations[0] as CLLocation

				let location = CLLocationCoordinate2D(latitude: userlocation.coordinate.latitude, longitude: userlocation.coordinate.longitude)
				let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
				let region = MKCoordinateRegion(center: location, span: span)
				mapView.setRegion(region, animated: true)
		}
		
		func locationManager(_ manager: CLLocationManager, didFailWithError error: Swift.Error) {
				print("err")
		}
}



struct RouteDetailedUIModel {
		let path: [Point]
		let description: String
		let minimodel: RouteUIModel
}

struct Point {
		let latitide: Double
		let longitude: Double
		let tags: [String] = []
}


protocol RouteProvider {
		func getFullModel(route: RouteUIModel) -> RouteDetailedUIModel
}

final class RouteClient: RouteProvider {
		func getFullModel(route: RouteUIModel) -> RouteDetailedUIModel {
				return RouteDetailedUIModel(path: paths[route.id], description: "some", minimodel: route)
		}
}

let paths: [[Point]] = [
		[
				Point(latitide: 55.7628, longitude: 37.6043),
				Point(latitide: 55.7638, longitude: 37.6143),
				Point(latitide: 55.7648, longitude: 37.6243),
				Point(latitide: 55.7658, longitude: 37.6143),
				Point(latitide: 55.7668, longitude: 37.6193),
				Point(latitide: 55.7678, longitude: 37.6203),
				Point(latitide: 55.768945, longitude: 37.6159)],
		[Point(latitide: 55.763183, longitude: 37.634141), Point(latitide: 55.767134, longitude: 37.659785)],
		[Point(latitide: 55.7928, longitude: 37.6043), Point(latitide: 55.798945, longitude: 37.6259)]
]
