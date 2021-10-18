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
    var archivedTime: Int64?
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
    
    var toDict: [String: Any] {
        
        return [
            "id": id as Any,
            "title": title as Any,
            "emoji": emoji as Any,
            "is_starred": isStarred as Any,
            "is_archived": isArchived as Any,
            "archived_time": archivedTime as Any,
            "contents": contents as Any,
            "conclusion": conclusion as Any,
            "created_time": createdTime as Any
        ]
    }
    
}
