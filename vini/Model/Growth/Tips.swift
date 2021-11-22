//
//  Tips.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/11/19.
//

import Foundation

enum Tips: String, CaseIterable {
    
    case homePageDefaultText = "最近有什麼想成長的事情？\n點擊右上角的＋號開始新增吧！"
    case longPressTips = "Tips：\n長按卡片可以觸發功能選單"
    
    static func randomText() -> String {
        
        let tips = Tips.allCases
        let index = Int.random(in: 0..<tips.count)
        
        return tips[index].rawValue
    }
    
}
