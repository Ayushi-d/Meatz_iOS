//
//  AppDelegate.swift
//  Meatz
//
//  Created by Mohamed Zead on 3/21/21.
//

//import FBSDKCoreKit
//import Firebase
//import FirebaseInstanceID
//import FirebaseMessaging
import GoogleSignIn
import IQKeyboardManagerSwift
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var coordinator: IntroCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configGoogleSignIn()
        configKeyboard()
       // acceptTermsWithConditionsForFacebookSDK()
        configureRemoteNotificaitonSetting(application)
        startApp()
        setupTabBarFont()
        MOLH.shared.activate(true)
        return true
    }

    private func startApp() {
        let navController = MainNavigationController()
        coordinator = IntroCoordinator(navController)
        coordinator?.start()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }

    private func setupTabBarFont() {
        UITabBarItem.appearance()
            .setTitleTextAttributes(
                [NSAttributedString.Key.font: FontsType.regular.getFontWithSize(11) as Any],
                for: .normal)
    }

    private func configGoogleSignIn() {
//        GIDSignIn.sharedInstance.clientID = R.string.localizable.googleApiKey()
    }

    private func configKeyboard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }

//    fileprivate func acceptTermsWithConditionsForFacebookSDK() {
//        ApplicationDelegate.initializeSDK(nil)
//        Settings.isAutoLogAppEventsEnabled = true
//        Settings.isAdvertiserIDCollectionEnabled = true
//    }

//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
//        let facebookHandle = ApplicationDelegate.shared.application(app, open: url, options: options)
//        return facebookHandle
//    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let scheme = url.scheme,
            scheme.localizedCaseInsensitiveCompare("com.app.meatz1234") == .orderedSame,
            let view = url.host {
            
            var parameters: [String: String] = [:]
            URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach {
                parameters[$0.name] = $0.value
            }
            
            
        }
        return true
    }
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        guard let inCommingURL = userActivity.webpageURL else { return false }
        print("Incomming Web Page URL: \(inCommingURL)")
        //shareLinkHandling(inCommingURL)
        return true
    }
}

// MARK: - Push Notifications

extension AppDelegate: UNUserNotificationCenterDelegate {
    func openApplication(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        if let launchOptions = launchOptions,
           let userInfo = launchOptions[.remoteNotification] as? [AnyHashable: Any]
        {
            detectNotificationType(userInfo: userInfo)
        } else {
            startApp()
        }
    }

    func configureRemoteNotificaitonSetting(_ application: UIApplication) {
//        FirebaseApp.configure()
//        Messaging.messaging().delegate = self
//        if MOLHLanguage.isArabic() {
//            Messaging.messaging().subscribe(toTopic: "IOS_ar")
//            Messaging.messaging().unsubscribe(fromTopic: "IOS_en")
//        } else {
//            Messaging.messaging().subscribe(toTopic: "IOS_en")
//            Messaging.messaging().unsubscribe(fromTopic: "IOS_ar")
//        }

        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, error in
                if let error = error {
                    print("requestAuthorization Error: \(error.localizedDescription)")
                }
            }

        } else {
            let settings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
    }

//    func messaging(_: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        SHeaders.shared.updateFirbaseToken(fcmToken)
//        UserDefaults.standard.set(fcmToken, forKey: "FBTOKEN")
//    }
//
//    func userNotificationCenter(_: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler _: @escaping () -> Void) {
//        print("did receive")
//        print(response.notification.request.content.userInfo)
//        let userinfo = response.notification.request.content.userInfo
//        detectNotificationType(userInfo: userinfo)
//    }
//
//    func userNotificationCenter(_: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        print(notification.request.content.userInfo)
//        completionHandler([.alert, .badge, .sound])
//    }
}
