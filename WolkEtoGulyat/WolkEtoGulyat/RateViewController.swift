import UIKit
import SwiftUI


final class RateViewController: UIViewController {
		
		private let route: RouteDetailedUIModel
		
		init(route: RouteDetailedUIModel) {
				self.route = route
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
				let rateview = UIHostingController(rootView: Rate(buttonAction: { [weak self] num in
						print(num)
						self?.navigationController?.popToRootViewController(animated: true)
				})).view
				if let rateview {
						view.addSubview(rateview)
						rateview.frame = view.bounds
				}
				navigationItem.setHidesBackButton(true, animated: false)
		}
		
}


struct Rate: View {
		
		@State private var rating: Int = 0
		var buttonAction: (Int) -> Void
		
		var body: some View {
				VStack(spacing: 20) {
						Text("Rate this route")
								.font(.headline)
						HStack {
								ForEach(1..<6) { num in
										if rating < num {
												Image(systemName: "star")
														.font(.largeTitle)
														.onTapGesture {
																rating = num
														}
										} else {
												Image(systemName: "star.fill")
														.font(.largeTitle)
														.foregroundColor(.yellow)
														.onTapGesture {
																if rating == num {
																		rating = 0
																} else {
																		rating = num
																}
														}
										}
								}
						}
						Button("Rate") {
								buttonAction(rating)
						}
				}
		}
}
