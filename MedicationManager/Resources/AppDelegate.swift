//
//  AppDelegate.swift
//  MedicationManager
//
//  Created by Sebastian Banks on 3/29/22.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { authorized, error in
            if let error = error {
                print("There was an error requesting permission to show local notifications: \(error)")
            }
            
            if authorized {
                UNUserNotificationCenter.current().delegate = self
                self.setNotifCategories()
                print("✅ User granted authorization to show local notifications")
            } else {
                print("🛑 User denied authorization to show local notifications")
            }
        }
        
        
        return true
    }
    
    private func setNotifCategories() {
        let markTakenAction = UNNotificationAction(
            identifier: Strings.markTakenActionIdentifier,
            title: "Taken",
            options: UNNotificationActionOptions(rawValue: 0))
        
        let ignoreAction = UNNotificationAction(
            identifier: Strings.ignoreActionIdentifier,
            title: "Ignore",
            options: UNNotificationActionOptions(rawValue: 0))
        
        let category = UNNotificationCategory(
            identifier: Strings.notifCategoryID,
            actions: [ignoreAction, markTakenAction],
            intentIdentifiers: [],
            hiddenPreviewsBodyPlaceholder: "",
            options: .customDismissAction
        )
        UNUserNotificationCenter.current().setNotificationCategories([category])
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

    // MARK: - Core Data stack

    

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Strings.medicationReminderRecieved), object: self)
        completionHandler([.sound, .badge, .banner])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == Strings.markTakenActionIdentifier, let id = response.notification.request.content.userInfo[Strings.medicationIDKey] as? String {
            MedicationController.shared.markMedicationTaken(withID: id)
            completionHandler()
        }
    }
}

