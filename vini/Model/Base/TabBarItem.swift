//
//  TabBarItem.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/11/10.
//

import Foundation

enum TabBarItem: Int, CaseIterable {
    case growth = 0
    case discover
    case mailbox
    case achievement
    
    var title: String {
        
        switch self {
        case .growth:
            return "成長"
            
        case .discover:
            return "探索"
            
        case .mailbox:
            return "信箱"
            
        case .achievement:
            return "成就"
        }
        
    }
}
