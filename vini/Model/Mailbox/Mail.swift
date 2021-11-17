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
    var receipientID: String
    var displayWondering: String
    var content: String
    var senderDisplayName: String
    var senderViniType: String
    var senderID: String
    var sentTime: Timestamp?
    var readTimestamp: Timestamp?
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case receipientID = "receipient_id"
        case displayWondering = "display_wondering"
        case content
        case senderDisplayName = "sender_display_name"
        case senderViniType = "sender_vini_type"
        case senderID = "sender_id"
        case sentTime = "sent_time"
        case readTimestamp = "read_timestamp"
    }
    
    init() {
        self.id = ""
        self.receipientID = ""
        self.displayWondering = ""
        self.content = ""
        self.senderDisplayName = ""
        self.senderViniType = "vini_amaze"
        self.senderID = ""
        self.sentTime = nil
        self.readTimestamp = nil
    }
    
    mutating func setupWelcomeMail() {
        
        self.displayWondering = "如何成為更好的人？"
        self.content = "嗨，歡迎你來到這裡!"
        self.senderDisplayName = "某個也在努力成長的Vini"
        self.senderID = MailManager.shared.welcomeMailSenderID
        self.senderViniType = UIImage.AssetIdentifier.amaze.name
        self.readTimestamp = Timestamp(date: Date())
        
        if let mail = Bundle.main.object(forInfoDictionaryKey: "WelcomeMail") as? String {
            self.content = mail
        }
    }
       
}
