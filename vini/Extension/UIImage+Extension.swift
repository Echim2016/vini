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
                
            }
        }
    }
    
    convenience init?(assetIdentifier: AssetIdentifier) {
        
        self.init(named: assetIdentifier.name)
    }
}
