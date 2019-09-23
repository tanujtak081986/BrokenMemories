//
//  AppDelegate.swift
//  Memories
//
//  Created by tanuj tak on 5/9/19.
//  Copyright © 2019 tanujtak. All rights reserved.
//

import Firebase
import UIKit
import CodableFirebase
import UserNotifications
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        //Configure firebase
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        setInitialMemoryCard()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func setInitialMemoryCard() {
        if UserDefaults.standard.value(forKey: AppStrings.Keys.sequence) == nil {
            UserDefaults.standard.setValue(0, forKey: AppStrings.Keys.sequence)
        }
    }
    
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    //MARK: - User Notification Center Delegates
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    
        completionHandler([.badge, .alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.notification.request.identifier == "memory.category" {
            //increment sequence
            if let currentSeq = UserDefaults.standard.value(forKey: AppStrings.Keys.sequence) as? Int {
                UserDefaults.standard.setValue(currentSeq+1, forKey: AppStrings.Keys.sequence)
            }
            NotificationCenter.default.post(name: .notificationTriggered, object: nil)
        }
        
        completionHandler()
        
    }
}

