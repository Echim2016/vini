//
//  Timestamp+Extension.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/30.
//

import Foundation
import FirebaseFirestore

extension Timestamp {
    
    func toString() -> String {
        
        let date = self.dateValue()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        
        return dateFormatter.string(from: date)
    }
    
    func toDate() -> Date {
        
        return self.dateValue()
    }
    
}
