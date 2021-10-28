//
//  User.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/28.
//

import Foundation
import FirebaseFirestore

struct User: Codable {
    
    var id: String
    var viniType: String
    var displayName: String
    var wondering: String
    var isPublished: Bool
    
    enum CodingKeys: String, CodingKey {
        
        case id = "user_id"
        case viniType = "vini_type"
        case displayName = "display_name"
        case wondering
        case isPublished = "is_published"
    }
    
    init() {
        self.id = ""
        self.viniType = ""
        self.displayName = "Vini"
        self.wondering = "How to sleep well?"
        self.isPublished = false
    }
}
