import UIKit


final class AppCoordinator {
		let tabBarController: UITabBarController
		let window: UIWindow

		init(window: UIWindow) {
				self.window = window
				tabBarController = UITabBarController()
		}

		func start() {
				window.rootViewController = tabBarController
				window.makeKeyAndVisible()
				
				let mainVC: ViewController = ViewController()
				let mainNC: UINavigationController = UINavigationController(rootViewController: mainVC)
				let selfVC: MakeRouteController = MakeRouteController()
				let selfNC: UINavigationController = UINavigationController(rootViewController: selfVC)

				tabBarController.setViewControllers([mainNC, selfNC], animated: true)
				
				mainNC.tabBarItem = UITabBarItem(
						title: "Find routes",
						image: UIImage(systemName: "magnifyingglass"),
						selectedImage: UIImage(systemName: "magnifyingglass")
				)
				selfNC.tabBarItem = UITabBarItem(
						title: "Make route",
						image: UIImage(systemName: "plus.square.on.square"),
						selectedImage: UIImage(systemName: "plus.square.on.square.fill")
				)
		}
}
