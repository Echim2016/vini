//
//  Array+Extension.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/11/10.
//

import Foundation

extension Array where Element: Equatable {
    
    mutating func removeObject(object: Element) {
        
        if let index = firstIndex(of: object) {
            remove(at: index)
        }
    }
    
}
