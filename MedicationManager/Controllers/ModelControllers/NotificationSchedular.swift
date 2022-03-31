//
//  NotificationSchedular.swift
//  MedicationManager
//
//  Created by Sebastian Banks on 3/30/22.
//

import Foundation
import UserNotifications

class NotificationSchedular {
    
    
    
    func scheduleNotif(for medication: Medication) {
        guard let id = medication.id, !id.isEmpty else { return }
        let content = UNMutableNotificationContent()
        content.title = "Take You're Meds"
        content.body = "Time to take some \(medication.name)"
        content.sound = .default
        content.badge = 1
        content.userInfo = [Strings.medicationIDKey:id]
        content.categoryIdentifier = Strings.notifCategoryID
        
        let triggerDate = Calendar.current.dateComponents([.hour, .minute], from: medication.timeOfDay ?? Date())
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: triggerDate,
            repeats: true
        )
        let request = UNNotificationRequest(
            identifier: id,
            content: content,
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Unable to scheduld notification \(error)")
            }
        }
    }
    
    func cancelNotif(for medication: Medication) {
        guard let id = medication.id else { return }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
}
