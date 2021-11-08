//
//  Date+Extension.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/11/3.
//

import Foundation

extension Date {
    
    func getDayDistance(to date: Date, calendar: Calendar = .current) -> Int {
                
        let difference = calendar.dateComponents([.day], from: self, to: date)

        return difference.day ?? 0
    }
    
}
