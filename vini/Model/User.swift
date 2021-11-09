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
    var cloudCategory: String?
    var preferredReflectionTime: Int?
    var createdTime: Timestamp?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "user_id"
        case viniType = "vini_type"
        case displayName = "display_name"
        case wondering
        case isPublished = "is_published"
        case cloudCategory = "cloud_category"
        case preferredReflectionTime = "preferred_reflection_hour"
        case createdTime = "created_time"
    }
    
    init() {
        self.id = ""
        self.viniType = UIImage.AssetIdentifier.amaze.name
        self.displayName = "Vini"
        self.wondering = ""
        self.isPublished = true
        self.cloudCategory = CloudCategory.lifestyle.category
        self.preferredReflectionTime = 23
        self.createdTime = Timestamp(date: Date())
    }
}
