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
    
    var settingItems: [String] {
        
        switch self {
            
        case .notification:
            return ["每日反思時間"]
            
        case .account:
            return ["已封鎖的使用者" ,"登出"]
            
        case .about:
            return ["隱私權政策"]
        }
    }
    
}
