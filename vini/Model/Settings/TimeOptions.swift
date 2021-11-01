//
//  TimeOptions.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/31.
//

import Foundation

enum TimeOptions: Int, CaseIterable {
    
    case clock20 = 0
    case clock21
    case clock22
    case clock23
    case clock24
    
    var hour: Int {
        
        switch self {
            
        case .clock20: return 20
        case .clock21: return 21
        case .clock22: return 22
        case .clock23: return 23
        case .clock24: return 24
        }
    }
    
    var toString: String {
        
        switch self {
            
        case .clock20: return "20:00 - 21:00"
        case .clock21: return "21:00 - 22:00"
        case .clock22: return "22:00 - 23:00"
        case .clock23: return "23:00 - 24:00"
        case .clock24: return "24:00 - 01:00"
        }
    }
}
