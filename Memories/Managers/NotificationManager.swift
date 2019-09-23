//
//  NotificationManager.swift
//  Memories
//
//  Created by tanuj tak on 5/15/19.
//  Copyright © 2019 tanujtak. All rights reserved.
//

import Foundation
import UserNotifications

struct NotificationManager {
    
    //Adds a scheduled local notification trigger to be repeated.
    func addNotificationTriggerFromNowFor(component: String, interval: Int, fireDate: Date?) {
        
        UNUserNotificationCenter.current().requestAuthorization( options: [.badge, .alert, .sound]) { (granted, error) in
            
            if let error = error {
                print("granted, but Error in notification permission:\(error.localizedDescription)")
            }
            
            UNUserNotificationCenter.current().getPendingNotificationRequests { (notifications) in
                if notifications.count == 0 {
                    self.removeAllPendingNotifications()
                    var resultDate = Date()
                    let componentValue = self.getCalenderComponentForValue(component)
                    
                    if let dateByComponent = Calendar.current.date(byAdding: componentValue, value: interval, to: Date()) {
                        resultDate = dateByComponent
                    }
                    if let userDate = fireDate {
                        resultDate = userDate
                    }
                    _ = self.scheduleNotification(fireDate: resultDate, repeatComponent: componentValue, repeatInterval: interval)
                }
            }
        }
    }
    
    func scheduleNotification(fireDate: Date, repeatComponent: Calendar.Component, repeatInterval: Int = 1) {
        
        let content = UNMutableNotificationContent()
        content.title = "New memory available."
        content.body = "Tap here to see your hourly dose of Memory"
        content.categoryIdentifier = "memory.category"
        content.sound = .init(named: .init("slow-spring-board"))
//        content.sound = .init(named: .init("RajasthanTourismSlow.mp3"))
        

        let fireTrigger = UNTimeIntervalNotificationTrigger(timeInterval: fireDate.timeIntervalSinceNow, repeats: false)
        
        let fireDateRequest = UNNotificationRequest(identifier: "memory.category", content: content, trigger: fireTrigger)
        
        UNUserNotificationCenter.current().add(fireDateRequest) {(error) in
            if let error = error {
                print("Error adding firing notification: \(error.localizedDescription)")
            } else {
                
                if let firstRepeatingDate = Calendar.current.date(byAdding: repeatComponent, value: repeatInterval, to: fireDate) {
                    
                    let repeatingTrigger = UNTimeIntervalNotificationTrigger(timeInterval: firstRepeatingDate.timeIntervalSinceNow, repeats: true)
                    
                    let repeatingRequest = UNNotificationRequest(identifier: "memory.category", content: content, trigger: repeatingTrigger)
                    
                    UNUserNotificationCenter.current().add(repeatingRequest) { (error) in
                        if let error = error {
                            print("Error adding repeating notification: \(error.localizedDescription)")
                        } else {
                            print("Successfully scheduled")
                            //Successfully scheduled
                        }
                    }
                    
                }
            }
        }
        
    }
    
    func removeAllPendingNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func removePendingNotificationsForIdentifier(_ identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    private func getCalenderComponentForValue(_ value: String) -> Calendar.Component {
        switch value.lowercased() {
        case "era":
            return .era
        case "year":
            return .year
        case "month":
            return .month
        case "day":
            return .day
        case "hour":
            return .hour
        case "minute":
            return .minute
        case "second":
            return .second
        case "weekday":
            return .weekday
        case "weekdayOrdinal":
            return .weekdayOrdinal
        case "quarter":
            return .quarter
        case "weekOfMonth":
            return .weekOfMonth
        case "weekOfYear":
            return .weekOfYear
        case "yearForWeekOfYear":
            return .yearForWeekOfYear
        case "nanosecond":
            return .nanosecond
        default:
            //return hourly for defaults
            return.hour
        }
    }
}
