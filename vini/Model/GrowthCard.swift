//
//  GrowthCard.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/18.
//

import Foundation
import FirebaseFirestore

struct GrowthCard: Codable {
    
    var id: String
    var title: String
    var emoji: String
    var isStarred: Bool
    var isArchived: Bool
    var archivedTime: Timestamp?
    var contents: [GrowthContent]?
    var conclusion: String?
    var createdTime: Timestamp?
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case title
        case emoji
        case isStarred = "is_starred"
        case isArchived = "is_archived"
        case archivedTime = "archived_time"
        case contents
        case conclusion
        case createdTime = "created_time"
    }
    
}
