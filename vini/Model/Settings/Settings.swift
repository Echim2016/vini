//
//  Settings.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/31.
//

import Foundation

enum SettingsSection: Int, CaseIterable {
    
    case notificationSettings = 0
    case accountSettings
    
    var title: String {
        
        switch self {
            
        case .notificationSettings:
            return "提醒設定"
            
        case .accountSettings:
            return "帳戶設定"
        }
    }
    
    var settingItems: [String] {
        
        switch self {
            
        case .notificationSettings:
            return ["每日反思時間"]
            
        case .accountSettings:
            return ["已封鎖的使用者" ,"登出"]
        }
    }
    
}
