import UIKit

final class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(true, forKey: "visited")
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .ypWhiteDay
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        tabBar.tintColor = .ypBlue
        
        let trackerStore = TrackerStore()
        let trackerVC = UINavigationController(rootViewController: TrackerViewController(trackerStore: trackerStore))
        let statisticVC = StatisticViewController()
        let statisticViewModel = StatisticViewModel()
        statisticVC.statisticViewModel = statisticViewModel
        
        trackerVC.tabBarItem = UITabBarItem(
            title: NSLocalizedString("TrackerViewController.title", comment: ""),
            image: UIImage(named: "Tab Bar Circle"),
            selectedImage: nil
        )
        statisticVC.tabBarItem = UITabBarItem(
            title: NSLocalizedString("StatisticViewController.title", comment: ""),
            image: UIImage(named: "Tab Bar Rabbit"),
            selectedImage: nil
        )
        
        setViewControllers([trackerVC, statisticVC], animated: true)
    }
}
