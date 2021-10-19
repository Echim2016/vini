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
    var growthCardId: DocumentReference
    var title: String
    var content: String
    var image: String
    var createdTime: Timestamp
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case growthCardId = "growth_card_id"
        case title
        case content
        case image
        case createdTime = "created_time"
    }
    
    var toDict: [String: Any] {
        
            return [
                "id": id as Any,
                "growth_card_id": growthCardId as Any,
                "title": title as Any,
                "content": content as Any,
                "image": image as Any,
                "createdTime": createdTime as Any
            ]
        }
    
}
