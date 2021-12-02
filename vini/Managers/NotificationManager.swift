//
//  NotificationManager.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/11/4.
//

import Foundation
import UserNotifications

class NotificationManager {
    
    static let shared = NotificationManager()
    
    var reflectionTime = 23
    
    func setupReflectionNotification() {
        
        MailManager.shared.getReflectionTime { result in
            
            switch result {
                
            case .success(let hour):
                
                self.reflectionTime = hour
                self.setupNotificationSchedule(hour: self.reflectionTime)
                
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
    func setupNotificationSchedule(hour: Int = 23) {
        
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        
        content.title = "每日反思提醒"
        content.body = "晚安～ 今天還好嗎？現在就開始進行每日反思吧！"
        content.sound = .default
        
        if let date = Calendar.current.date(bySettingHour: hour, minute: 0, second: 0, of: Date()) {
            
            let fireDate = Calendar.current.dateComponents([.hour, .minute], from: date)

            let trigger = UNCalendarNotificationTrigger(dateMatching: fireDate, repeats: true)
            
            let request = UNNotificationRequest(identifier: "reflection", content: content, trigger: trigger)
            
            center.add(request) { (error) in
                
                if error != nil {
                    print("Error = \(error?.localizedDescription ?? "error local notification")")
                }
            }
        }
    }
    
}
