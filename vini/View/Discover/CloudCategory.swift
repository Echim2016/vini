//
//  CloudCategory.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/11/8.
//

import Foundation
import UIKit

enum CloudCategory: Int, CaseIterable {
    
    case career = 0
    case relationship
    case selfGrowth
    case lifestyle
    
    var category: String {
        
        return "\(self.self)"
    }
    
    var title: String {
        
        switch self {
            
        case .career:
            return "工作職涯"
            
        case .relationship:
            return "感情關係"
            
        case .selfGrowth:
            return "自我提升"
            
        case .lifestyle:
            return "生活哲學"
        }
    }
    
    var introduction: String {
        
        switch self {
            
        case .career:
            return "關於工作、關於生產力、關於職涯的那些你不得不面對、又常讓你迷失方向的大小事。"
            
        case .relationship:
            return "關於感情、關於關係、關於人與人之間那些難以捉摸、又常讓你深陷其中的大哉問。"
            
        case .selfGrowth:
            return "關於個人、關於成長、關於為了讓自己變得更好，而一直不斷在嘗試與挫折中輪迴的故事。"
            
        case .lifestyle:
            return "關於生活、關於生存、關於活著的那些不曾談論、卻讓你找不到答案的事情。"
        }
    }
    
    var colors: [CGColor] {
        
        switch self {
            
        case .career:
            return [
                UIColor(red: 0/255, green: 150/255, blue: 199/255, alpha: 1.0).cgColor,
                UIColor(red: 72/255, green: 149/255, blue: 239/255, alpha: 1.0).cgColor,
                UIColor(red: 2/255, green: 48/255, blue: 71/255, alpha: 1.0).cgColor
            ]
            
        case .relationship:
            return [
                UIColor(red: 234/255, green: 172/255, blue: 139/255, alpha: 1.0).cgColor,
                UIColor(red: 181/255, green: 101/255, blue: 118/255, alpha: 1.0).cgColor,
                UIColor(red: 53/255, green: 80/255, blue: 112/255, alpha: 1.0).cgColor
            ]
            
        case .selfGrowth:
            return [
                UIColor(red: 82/255, green: 182/255, blue: 154/255, alpha: 1.0).cgColor,
                UIColor(red: 22/255, green: 139/255, blue: 173/255, alpha: 1.0).cgColor,
                UIColor(red: 24/255, green: 78/255, blue: 119/255, alpha: 1.0).cgColor
            ]
            
        case .lifestyle:
//            return [
//                UIColor(red: 128/255, green: 155/255, blue: 206/255, alpha: 1.0).cgColor,
//                UIColor(red: 184/255, green: 224/255, blue: 210/255, alpha: 1.0).cgColor,
//                UIColor(red: 234/255, green: 196/255, blue: 213/255, alpha: 1.0).cgColor
//            ]
            
            return [
                UIColor(red: 248/255, green: 129/255, blue: 117/255, alpha: 1.0).cgColor,
                UIColor(red: 85/255, green: 80/255, blue: 126/255, alpha: 1.0).cgColor,
                UIColor.B2.cgColor
            ]
        }
    }
    
}

struct CloudCategorySelection {
    
    var category: CloudCategory
    var isChecked: Bool
    
    init(category: CloudCategory, isChecked: Bool = false) {
        
        self.category = category
        self.isChecked = isChecked
    }
}
