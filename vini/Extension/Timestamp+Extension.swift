//
//  Timestamp+Extension.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/30.
//

import Foundation
import FirebaseFirestore

extension Timestamp {
    
    func toString(format: DateFormat) -> String {
        
        let date = self.dateValue()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        
        return dateFormatter.string(from: date)
    }
    
    func toDate() -> Date {
        
        return self.dateValue()
    }
    
}

enum DateFormat: String {
    
    case ymdFormat = "yyyy/MM/dd"
    case mailFormat = "yyyy/MM/dd HH:mm"
}
