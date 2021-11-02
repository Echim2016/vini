//
//  InsightTitle.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/11/2.
//

import Foundation

enum InsightTitle: Int, CaseIterable {
    
    case totalGrowthContentCards = 0
    case currentStreak
    case mostRecordedTimeInterval
    case mostRecordedGrowthCard
    
    var title: String {
        
        switch self {
            
        case .totalGrowthContentCards:
            return "微小學習的卡片總數"
            
        case .currentStreak:
            return "連續紀錄天數"
            
        case .mostRecordedTimeInterval:
            return "最常記下學習的時段"
            
        case .mostRecordedGrowthCard:
            return "最多微小學習的成長項目"
        }
        
    }
}
