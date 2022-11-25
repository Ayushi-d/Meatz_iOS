//
//  AppDelegate+Extension.swift
//  Le Service
//
//  Created by Nabil Elsherbene on 11/30/20.
//  Copyright © 2020 spark cloud. All rights reserved.
//

//import Firebase
//import FirebaseInstanceID
//import FirebaseMessaging
import UIKit
import UserNotifications

enum RemoteNotificationType {
    case order(orderId: Int)
}

extension AppDelegate {
    func detectNotificationType(userInfo: [AnyHashable: Any]) {
        let navigation = MainNavigationController()
        let coordinator = MainCoordinator(navigation)
        coordinator.start()
        guard let type = userInfo["type"] as? String else {
            return
        }

        switch type {
        case "order":
            guard let _newsId = userInfo["id"] as? String else { return }
            guard let id = Int(_newsId) else { return }
            coordinator.navigateTo(MainDestination.orderDetails(id))
        
        default:

            if topViewController() == nil {
                //startApp()
            } else {
                return
            }
        }
        
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
    }

    func detectNotificationAction(type: RemoteNotificationType) {
        let _viewController = detectNotificationViewController(type: type)

        if topViewController() == nil {
//            let navController = MainNavigationController()
//            mainCoordinator = MainCoordinator(navController)
//            let root = mainCoordinator?.factory.tabBar()
//            window?.rootViewController = root
//            root?.navigationController?.pushViewController(_viewController, animated: true)

        } else {
            topViewController()?.navigationController?.pushViewController(_viewController, animated: true)
        }
    }

    private func detectNotificationViewController(type: RemoteNotificationType) -> UIViewController {
        switch type {
        case let .order(orderId):
           
           // return MainFactory.shared.newsDetails(newsId)
        return UIViewController()
        }
    }

    func topViewController(_ base: UIViewController? = nil) -> UIViewController? {
        let base = base ?? UIApplication.shared.keyWindow?.rootViewController

        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)

        } else if let tab = base as? UITabBarController {
            guard let selected = tab.selectedViewController else { return base }
            return topViewController(selected)

        } else if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}

