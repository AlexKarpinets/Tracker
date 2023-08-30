import UIKit

final class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(true, forKey: "visited")
        view.backgroundColor = .ypWhite
        
        let trackerVC = UINavigationController(rootViewController: TrackerViewController())
        let statisticVC = UINavigationController(rootViewController: StatisticViewController())
        
        tabBar.layer.borderColor = UIColor.lightGray.cgColor
        tabBar.layer.borderWidth = 1
        tabBar.layer.masksToBounds = true
        
        trackerVC.tabBarItem.image = UIImage(named: "Tab Bar Circle")
        statisticVC.tabBarItem.image = UIImage(named: "Tab Bar Rabbit")
        
        trackerVC.title = "Трекеры"
        statisticVC.title = "Статистика"
        
        setViewControllers([trackerVC, statisticVC], animated: true)
    }
}
