//
//  InsightTitle.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/11/2.
//

import Foundation

enum InsightTitle: Int, CaseIterable {
    
    case totalGrowthContentCards = 0
    case totalArchivedCards
    case currentStreak
    case totalCardsInApp
    
    var title: String {
        
        switch self {
            
        case .totalGrowthContentCards:
            return "微小學習總數"
            
        case .totalArchivedCards:
            return "封存卡片總數"
            
        case .currentStreak:
            return "連續紀錄天數"
            
        case .totalCardsInApp:
            return "平台卡片總數"
        }
        
    }
}
