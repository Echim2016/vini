//
//  AppDelegate.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/17.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        UITabBar.appearance().tintColor = .white
        
        // User Notifications
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("User gave permissions for local notifications")
            }
        }
        
        // Update reflection notification
        NotificationManager.shared.setupNotificationSchedule()
        
        let firebaseAuth = Auth.auth()

        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
        return true
        
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

extension AppDelegate {
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            
            completionHandler([.alert])
    }
    
    // This function will be called right after user tap on the notification
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void) {
            
            if response.notification.request.identifier == "reflection" {
                
                guard let rootViewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController else {
                    return
                }
                
                // Instantiate and present the reflection view controller
                let reflectionStoryboard = UIStoryboard(name: "Reflection", bundle: nil)
                
                if let reflectionVC = reflectionStoryboard.instantiateViewController(withIdentifier: "Reflection") as? ReflectionViewController,
                   let tabBarVC = rootViewController as? UITabBarController {
                    
                    tabBarVC.selectedIndex = 0
                    tabBarVC.selectedViewController?.present(reflectionVC, animated: true, completion: nil)
                }
            }
            
            completionHandler()
        }
}
