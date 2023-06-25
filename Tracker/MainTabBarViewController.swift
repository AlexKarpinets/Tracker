import UIKit

final class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        
        let trackerVC = UINavigationController(rootViewController: TrackerViewController())
        let statisticVC = UINavigationController(rootViewController: StatisticViewController())
        
        trackerVC.tabBarItem.image = UIImage(named: "Tab Bar Circle")
        statisticVC.tabBarItem.image = UIImage(named: "Tab Bar Rabbit")
        
        trackerVC.title = "Трекеры"
        statisticVC.title = "Статистика"
        
        setViewControllers([trackerVC, statisticVC], animated: true)
    }
}
