//
//  Settings.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/31.
//

import Foundation

enum SettingsSection: Int, CaseIterable {
    
    case notification = 0
    case account
    case about
    
    var title: String {
        
        switch self {
            
        case .notification:
            return "提醒設定"
            
        case .account:
            return "帳戶設定"
            
        case .about:
            return "關於 Vini"
        }
    }
    
    var settingItems: [SettingsTitle] {
        
        switch self {
            
        case .notification:
            return [.reflectionTime]
            
        case .account:
            return [.blockedUsers, .logOut, .deleteAccount]
            
        case .about:
            return [.privacyPolicy]
        }
    }
    
}

enum SettingsTitle: Int, CaseIterable {
    
    case reflectionTime = 0
    case blockedUsers
    case logOut
    case deleteAccount
    case privacyPolicy
    
    var title: String {
        
        switch self {
            
        case .reflectionTime:
            return "每日反思時間"
            
        case .blockedUsers:
            return "已封鎖的使用者"
            
        case .logOut:
            return "登出"
            
        case .deleteAccount:
            return "刪除帳號"
            
        case .privacyPolicy:
            return "隱私權政策"
        }
    }
    
}
