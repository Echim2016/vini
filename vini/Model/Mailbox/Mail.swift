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
        
        self.displayWondering = "歡迎你來到這裡"
        
        // swiftlint:disable line_length
        self.content = "嗨，我是 Vini，歡迎你來到這裡，首先想謝謝你把時間留給自己。\n\n這裡是一個專注在捕捉個人學習的地方，每個使用者，都是一隻 Vini，你可以在成長頁面開啟自己近期想要累積的成長項目，並且能在每一張成長卡片裡面，新增微小學習卡片、瀏覽過去的成長累積歷程，當你發現你對你的成長項目有了新的觀點或是結論，你可以封存整個成長項目，更坦然地邁向下一個成長。對了，我在封存的按鈕上偷偷施了一些魔法，請好好紀錄下你的微小學習，然後試著封存你的第一個成長項目吧！\n\n另外，你也可以在探索頁面中，從不同的雲層，看見平台上不同的使用者們在在探尋些什麼，並且分享你的經驗或觀點給他。當然，你也可以選一個最符合你現況的雲層，在裡面公開提出你最近在思考的事情或個人最近的狀態。\n\n到了每天晚上的反思時段，你可以體驗 Vini 為你準備的幾個反思題目，也可以在這段時間，前往收信匣查看其他 Vini 寄給你的信件，如果你能從中得到啟發，那就太好了！\n\n「對生活中的小細節用心，就能把世界活得更寬闊」，這是我很喜歡的一句話，送給你，也期待你能在生活中捕捉到那些意想不到、但又讓你能不斷向前的微小學習，現在就去開啟自己的成長項目吧！"
        // swiftlint:able line_length

        self.senderDisplayName = "某個也在努力成長的Vini"
        self.senderID = "systemDefault"
        self.senderViniType = UIImage.AssetIdentifier.amaze.name
        self.readTimestamp = Timestamp(date: Date())
    }
       
}
