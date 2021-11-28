//
//  UIImage+Extension.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/27.
//

import UIKit
import Foundation

extension UIImage {
        
    enum AssetIdentifier: Int, CaseIterable {
        
        case amaze = 0
        case congrats
        case spark
        case dots
        case alert
        case feel
        case heart
        case question
        case shake
        case sweat
        case xmark
        
        var name: String {
            switch self {
            case .amaze:
                return "vini_amaze"
            case .congrats:
                return "vini_congrats"
            case .spark:
                return "vini_spark"
            case .dots:
                return "vini_dots"
            case .alert:
                return "vini_alert"
            case .feel:
                return "vini_feel"
            case .heart:
                return "vini_heart"
            case .question:
                return "vini_question"
            case .shake:
                return "vini_shake"
            case .sweat:
                return "vini_sweat"
            case .xmark:
                return "vini_xmark"
            }
        }
    }
    
    convenience init?(assetIdentifier: AssetIdentifier) {
        
        self.init(named: assetIdentifier.name)
    }
}
