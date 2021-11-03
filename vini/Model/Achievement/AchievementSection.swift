//
//  AchievementSection.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/11/2.
//

import UIKit


enum AchievementSection: Int, CaseIterable {
    
    case archivedCards = 0
    
    case insights
    
    var title: String {
        
        switch self {
            
        case .archivedCards:
            return "已封存卡片"
            
        case.insights:
            return "洞察數據"
        }
    }
    
}
