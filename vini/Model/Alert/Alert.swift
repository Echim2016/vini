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
    
    var title: String {
        
        switch self {
            
        case .reflectionTimeAlert:
            return "目前並非反思時段"
            
        case .logOutAlert:
            return "登出"
            
        }
    }
    
    var message: String {
        
        switch self {
            
        case .reflectionTimeAlert:
            return "反思功能僅在每日反思時段開放，晚點再回來看看吧！"
        case .logOutAlert:
            return "您確定要登出嗎？"
        }
    }
    
}
