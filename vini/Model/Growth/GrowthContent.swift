//
//  GrowthContent.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/18.
//

import Foundation
import FirebaseFirestore

struct GrowthContent: Codable {
    
    var id: String
    var userID: String
    var growthCardId: DocumentReference?
    var title: String
    var content: String
    var image: String
    var createdTime: Timestamp
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case userID = "user_id"
        case growthCardId = "growth_card_id"
        case title
        case content
        case image
        case createdTime = "created_time"
    }
    
    init() {
        
        self.id = ""
        self.userID = ""
        self.growthCardId = nil
        self.title = ""
        self.content = ""
        self.image = ""
        self.createdTime = Timestamp()
    }
    
}
