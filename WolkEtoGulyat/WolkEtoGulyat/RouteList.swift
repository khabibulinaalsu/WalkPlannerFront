import UIKit
import SwiftUI


final class RouteListView: UIView {
		
		var routesToPresent: [RouteUIModel]
		weak var parent: UIViewController?
		
		init(routesToPresent: [RouteUIModel], parent: UIViewController, frame: CGRect) {
				self.routesToPresent = routesToPresent
				self.parent = parent
				super.init(frame: frame)
				configureUI()
		}
		
		required init?(coder: NSCoder) {
				fatalError("init(coder:) has not been implemented")
		}
		
		private func configureUI() {
				let routelist = UIHostingController(rootView: RouteList { [weak self] route in
						self?.parent?.navigationController?.pushViewController(RouteDetailedController(route: route), animated: true)
				}).view
				if let routelist {
						addSubview(routelist)
						routelist.frame = bounds
				}
		}
		
}


struct RouteList: View {
		
		@State public var routesToPresent: [RouteUIModel] = [
				.init(id: 0, title: "Ryadom s VDNH", author: "admin", rating: 4.5, distance: 2.03, duration: 35.4, image: UIImage(named: "route"), pointsOfInterest: ["Sobor Vasiliya Blazhenogo", "VDNH"]),
				.init(id: 1, title: "Moscow Peter", author: "admin", rating: 5.0, distance: 1.03, duration: 25.4, image: UIImage(named: "route"), pointsOfInterest: ["Park Gorkogo", "Petergof"])
		]
		public var toDetailedView: (RouteUIModel) -> Void
		
		var body: some View {
				ScrollView {
						VStack {
								ForEach(routesToPresent) { route in
										RouteCard(route: route)
												.onTapGesture {
														toDetailedView(route)
												}
								}
						}
				}
		}
}


struct RouteCard: View {
		
		private var route: RouteUIModel
		init(route: RouteUIModel) {
				self.route = route
		}
		
		var body: some View {
				HStack {
						VStack(alignment: .leading, spacing: 0) {
								Spacer()
								Text(route.title)
										.font(.headline)
								Text(route.author)
										.font(.subheadline)
								Spacer()
										.frame(height: 2)
								InfoCards(route: route)
								if route.pointsOfInterest.count > 0 {
										Spacer()
												.frame(height: 6)
										HStack(spacing: 6) {
												Text(route.pointsOfInterest[0])
														.font(.caption)
														.padding(6)
														.background(.blue.opacity(0.3))
														.cornerRadius(10)
												if route.pointsOfInterest.count > 1 {
														Text(route.pointsOfInterest[1])
																.font(.caption)
																.padding(6)
																.background(.blue.opacity(0.3))
																.cornerRadius(10)
														if route.pointsOfInterest.count > 2 {
																Text(route.pointsOfInterest[2])
																		.font(.caption)
																		.padding(6)
																		.background(.blue.opacity(0.3))
																		.cornerRadius(10)
														}
												}
										}
								}
								Spacer()
						}
						.padding(.leading, 16)
						Spacer()
						Image(uiImage: route.image ?? UIImage())
								.resizable()
								.scaledToFill()
								.clipped()
								.frame(width: 130, height: 130)
								.cornerRadius(24)
								.padding(.trailing, 16)
								.padding(.vertical, 8)
								.shadow(color: .gray , radius: 5, x: 3, y: 3)
				}
		}
}

struct InfoCards: View {
		private var route: RouteUIModel
		init(route: RouteUIModel) {
				self.route = route
		}
		
		var body: some View {
				HStack(spacing: 6) {
						Text("\(route.distance, specifier: "%.2f")km")
								.font(.caption)
								.padding(6)
								.background(.tertiary)
								.cornerRadius(10)
						Text("\(route.duration, specifier: "%.1f")min")
								.font(.caption)
								.padding(6)
								.background(.tertiary)
								.cornerRadius(10)
						Label("\(route.rating, specifier: "%.1f")", systemImage: "star.fill")
								.font(.caption)
								.padding(6)
								.background(.tertiary)
								.cornerRadius(10)
				}
		}
}


struct RouteUIModel: Identifiable {
		let id: Int
		let title: String
		let author: String
		let rating: Double
		let distance: Double
		let duration: Double
		let image: UIImage?
		let pointsOfInterest: [String]
}

