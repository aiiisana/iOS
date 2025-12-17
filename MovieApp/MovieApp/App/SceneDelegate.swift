import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        setupGlobalAppearance()
        
        // Discover
        let discoverVC = DiscoverViewController()
        discoverVC.title = "Discover"
        let discoverNav = UINavigationController(rootViewController: discoverVC)
        discoverNav.tabBarItem = UITabBarItem(title: "Discover", image: UIImage(systemName: "film.stack"), tag: 0)
        
        // Watchlist
        let watchlistVC = WatchlistViewController()
        watchlistVC.title = "Watchlist"
        let watchlistNav = UINavigationController(rootViewController: watchlistVC)
        watchlistNav.tabBarItem = UITabBarItem(title: "Watchlist", image: UIImage(systemName: "bookmark.fill"), tag: 1)
        
        // Settings
        let settingsVC = SettingsViewController()
        settingsVC.title = "Settings"
        let settingsNav = UINavigationController(rootViewController: settingsVC)
        settingsNav.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 2)
        
        [discoverNav, watchlistNav, settingsNav].forEach {
            $0.navigationBar.prefersLargeTitles = true
        }
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [discoverNav, watchlistNav, settingsNav]
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window
    }

    private func setupGlobalAppearance() {
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithTransparentBackground()
        navAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        UINavigationBar.appearance().compactAppearance = navAppearance
        UINavigationBar.appearance().tintColor = .white
        
        let tabAppearance = UITabBarAppearance()
        tabAppearance.configureWithTransparentBackground()
        
        tabAppearance.stackedLayoutAppearance.normal.iconColor = .lightGray
        tabAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.lightGray]
        
        tabAppearance.stackedLayoutAppearance.selected.iconColor = .white
        tabAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        UITabBar.appearance().standardAppearance = tabAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabAppearance
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}
