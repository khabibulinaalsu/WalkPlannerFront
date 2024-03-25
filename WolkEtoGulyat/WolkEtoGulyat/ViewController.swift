import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController {
		
		override func viewWillAppear(_ animated: Bool) {
				self.tabBarController?.tabBar.isHidden = false
		}
		
		override func viewDidLoad() {
				super.viewDidLoad()
				view.backgroundColor = .white
				configureUI()
		}
		
		private func configureUI() {
				let routelist = RouteListView(routesToPresent: [], parent: self, frame: view.frame)
				view.addSubview(routelist)
		}

}
