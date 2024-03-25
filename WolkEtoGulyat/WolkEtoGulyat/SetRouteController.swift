import UIKit
import CoreLocation
import SwiftUI


final class SetRouteController: UIViewController {
		
		private let path: [CLLocation]
		private let pointsOfInterest: [String]
		
		init(path: [CLLocation], pois: Set<String>) {
				self.path = path
				self.pointsOfInterest = pois.filter({ _ in return true})
				super.init(nibName: nil, bundle: nil)
		}
		
		required init?(coder: NSCoder) {
				fatalError("init(coder:) has not been implemented")
		}
		
		override func viewDidLoad() {
				super.viewDidLoad()
				view.backgroundColor = .white
				configureUI()
		}
		
		private func configureUI() {
				let setrouteview = UIHostingController(rootView: SetRoute(buttonAction: { [weak self] title, description in
						let model = RouteDetailedUIModel(
								path: self?.path.map { loc in
								return Point(latitide: loc.coordinate.latitude, longitude: loc.coordinate.longitude)
						} ?? [Point](),
								description: description,
								minimodel: RouteUIModel(id: -1, title: title, author: "stub", rating: 0, distance: 4.5, duration: 55.7, image: nil, pointsOfInterest: self?.pointsOfInterest ?? [])
						)
						self?.navigationController?.popToRootViewController(animated: true)
				}, cancelAction: { [weak self] in
						self?.navigationController?.popToRootViewController(animated: true)
				})).view
				if let setrouteview {
						view.addSubview(setrouteview)
						setrouteview.frame = view.bounds
				}
				navigationItem.setHidesBackButton(true, animated: false)
		}
}


struct SetRoute: View {
		
		@State private var title: String = ""
		@State private var description: String = ""
		var buttonAction: (String, String) -> Void
		var cancelAction: () -> Void
		
		var body: some View {
				VStack {
						Text("Your route")
								.font(.headline)
						TextField("Title", text: $title)
								.padding()
						TextField("Description", text: $description)
								.padding()
						HStack {
								Button("Cancel") {
										cancelAction()
								}
								.frame(width: 150, height: 40)
								.background(.orange)
								.foregroundColor(.white)
								.cornerRadius(15)
								Button("Create") {
										if title.count > 0 {
												buttonAction(title, description)
										}
								}
								.frame(width: 150, height: 40)
								.background(.orange)
								.foregroundColor(.white)
								.cornerRadius(15)
						}
				}
		}
}
