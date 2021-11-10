//
//  Alert.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/11/7.
//

import Foundation

enum Alert {
    
    case reflectionTimeAlert
    case logOutAlert
    case blockUserAlert
    case unblockUserAlert
    case deleteMailAlert
    
    var title: String {
        
        switch self {
            
        case .reflectionTimeAlert:
            return "目前並非反思時段"
            
        case .logOutAlert:
            return "登出"
            
        case .blockUserAlert:
            return "封鎖此使用者"
            
        case .unblockUserAlert:
            return "解除封鎖"
            
        case .deleteMailAlert:
            return "刪除"
            
        }
    }
    
    var message: String {
        
        switch self {
            
        case .reflectionTimeAlert:
            return "反思功能僅在每日反思時段開放，晚點再回來看看吧！"
        case .logOutAlert:
            return "您確定要登出嗎？"
        case .blockUserAlert:
            return "您將不會在 Vini Cloud 及收信匣看到此使用者的內容，您可以隨時在設定頁解除封鎖。"
        case .unblockUserAlert:
            return "您確定要解除封鎖此使用者嗎？"
        case .deleteMailAlert:
            return "您確定要刪除此信件嗎？"
        }
    }
    
}
