//
//  MainTabBarController.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/22/21.
//

import UIKit

final class MainTabBarController: UITabBarController {
    weak var coordinator: MainCoordinator?
    
    lazy var items: [UITabBarItem] = [
        UITabBarItem(title: R.string.localizable.home(),
                     image: R.image.home(),
                     tag: 0),
        UITabBarItem(title: R.string.localizable.theShops(),
                     image: R.image.percentage1(),
                     tag: 1),
        UITabBarItem(title: R.string.localizable.myBoxes(),
                     image: R.image.deliveryBox(),
                     tag: 2),
        UITabBarItem(title: R.string.localizable.profile(),
                     image: R.image.user5(),
                     tag: 3),
        UITabBarItem(title: R.string.localizable.settings(),
                     image: R.image.settings(),
                     tag: 4),
    ]
    
    var controllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0..<controllers.count {
            controllers[i].tabBarItem = items[i]
        }
        tabBar.isTranslucent = false
        tabBar.tintColor = R.color.maetzLightRed()
        tabBar.barTintColor = R.color.meatzRed()
        tabBar.unselectedItemTintColor = R.color.meatzTabbarPink()

        addSubViewController()
    }
    
    fileprivate func addSubViewController() {
        setViewControllers(controllers, animated: true)
    }
  
}
