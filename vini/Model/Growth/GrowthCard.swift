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
    var userID: String
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
        case userID = "user_id"
        case title
        case emoji
        case isStarred = "is_starred"
        case isArchived = "is_archived"
        case archivedTime = "archived_time"
        case contents
        case conclusion
        case createdTime = "created_time"
    }
    
    init() {
        
        self.id = ""
        self.userID = ""
        self.title = ""
        self.emoji = ""
        self.isStarred = false
        self.isArchived = false
        self.archivedTime = nil
        self.contents = nil
        self.conclusion = nil
        self.createdTime = nil
    }
    
}
