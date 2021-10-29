//
//  Mail.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/29.
//

import Foundation
import FirebaseFirestore

struct Mail: Codable {
    
    var id: String
    var displayWondering: String
    var content: String
    var senderDisplayName: String
    var senderViniType: String
    var senderID: String
    var readTimestamp: Timestamp?
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case displayWondering = "display_wondering"
        case content
        case senderDisplayName = "sender_display_name"
        case senderViniType = "sender_vini_type"
        case senderID = "sender_id"
        case readTimestamp = "read_time_stamp"
    }
       
}
