//
//  Alert.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/11/7.
//

import Foundation

enum Alert {
    
    case reflectionTimeAlert
    
    var title: String {
        
        switch self {
            
        case .reflectionTimeAlert:
            return "目前並非反思時段"
            
        }
    }
    
    var message: String {
        
        switch self {
            
        case .reflectionTimeAlert:
            return "反思功能僅在每日反思時段開放，晚點再回來看看吧！"
            
        }
    }
    
    
}
