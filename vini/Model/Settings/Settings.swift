//
//  Settings.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/31.
//

import Foundation

enum SettingsSection: Int, CaseIterable {
    
    case notificationSettings = 0
    
    var title: String {
        
        switch self {
            
        case .notificationSettings:
            return "提醒設定"
        }
    }
    
}