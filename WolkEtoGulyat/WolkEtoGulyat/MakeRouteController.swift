import UIKit
import MapKit
import CoreLocation


final class MakeRouteController: UIViewController {
		
		private var path: [CLLocation] = []
		private var pointsOfInterest: Set<String> = Set<String>()
		private var isWalking: Bool = false
		
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
		
		private let startButton: UIButton = {
				let button = UIButton(type: .system)
				button.layer.cornerRadius = 15
				button.backgroundColor = .systemOrange
				button.tintColor = .white
				button.titleLabel?.font = .boldSystemFont(ofSize: 20)
				button.setTitle("Start walking", for: .normal)
				button.translatesAutoresizingMaskIntoConstraints = false
				return button
		}()
		
		init() {
				super.init(nibName: nil, bundle: nil)
		}
		
		required init?(coder: NSCoder) {
				fatalError("init(coder:) has not been implemented")
		}

		override func viewWillAppear(_ animated: Bool) {
				self.tabBarController?.tabBar.isHidden = false
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
				self.mapView.addSubview(startButton)
				startButton.addTarget(self, action: #selector(buttonTappeed), for: .touchUpInside)
				NSLayoutConstraint.activate([
						startButton.centerXAnchor.constraint(equalTo: self.mapView.centerXAnchor),
						startButton.heightAnchor.constraint(equalToConstant: 40),
						startButton.widthAnchor.constraint(equalToConstant: 200),
						startButton.bottomAnchor.constraint(equalTo: self.mapView.bottomAnchor, constant: -100)
				])
		}
		
		@objc
		private func buttonTappeed(_ sender: UIButton) {
				if isWalking {
						self.locationManager.stopUpdatingLocation()
						navigationController?.pushViewController(SetRouteController(path: path, pois: pointsOfInterest), animated: true)
						isWalking = false
						startButton.setTitle("Start walking", for: .normal)
				} else {
						isWalking = true
						startButton.setTitle("Finish walking", for: .normal)
						self.tabBarController?.tabBar.isHidden = true
				}
		}
		
}

extension MakeRouteController: MKMapViewDelegate, CLLocationManagerDelegate {
		func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
				
				let userlocation = locations[0] as CLLocation
				
				if isWalking {
						path.append(userlocation)
						let request = MKLocalPointsOfInterestRequest(center: userlocation.coordinate, radius: .init(5))
						request.pointOfInterestFilter = .init(including: [
								.airport, .amusementPark, .aquarium, .museum,
								.nightlife, .nationalPark, .park, .stadium, .theater,
								.university, .winery, .zoo, .marina
						])
						let search = MKLocalSearch(request: request)
						search.start { (response, error) in
								if let error = error {
										print("Error \(error) performing search for location")
								}

								if let response = response {
										for item in response.mapItems {
												self.pointsOfInterest.insert(item.name ?? "")
										}
								}
						}
				}

				let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
				let region = MKCoordinateRegion(center: userlocation.coordinate, span: span)
				mapView.setRegion(region, animated: true)
		}
		
		func locationManager(_ manager: CLLocationManager, didFailWithError error: Swift.Error) {
				print("err")
		}
}
