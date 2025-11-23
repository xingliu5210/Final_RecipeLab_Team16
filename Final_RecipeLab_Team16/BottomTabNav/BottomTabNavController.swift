import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        if let beigeColor = UIColor(named: "Beige") {
            tabBar.backgroundColor = beigeColor
            tabBar.barTintColor = beigeColor
        }

        let home = UINavigationController(rootViewController: MainPageController())
        home.tabBarItem = UITabBarItem(title: "Home",
                                       image: UIImage(systemName: "house"),
                                       tag: 0)

        let addRecipie = UINavigationController(rootViewController: AddRecipiePageController())
        addRecipie.tabBarItem = UITabBarItem(title: "Recipes",
                                          image: UIImage(systemName: "book"),
                                          tag: 1)

        let myRecipies = UINavigationController(rootViewController: MyRecipiePageController())
        myRecipies.tabBarItem = UITabBarItem(title: "Profile",
                                          image: UIImage(systemName: "person"),
                                          tag: 2)

        viewControllers = [home, addRecipie, myRecipies]
    }
}
