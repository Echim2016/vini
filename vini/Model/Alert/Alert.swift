//
//  Alert.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/11/7.
//

import Foundation

enum Alert {
    
    case reflectionTimeAlert
    case logOutAlert
    
    case blockUserAlert
    case unblockUserAlert
    
    case deleteMailAlert
    case deleteGrowthCardAlert
    
    case emptyInputAlert
    
    case sendMailAlert
    
    case updateContentCardAlert
    
    var title: String {
        
        switch self {
            
        case .reflectionTimeAlert:
            return "目前並非反思時段"
            
        case .logOutAlert:
            return "登出"
            
        case .blockUserAlert:
            return "封鎖此使用者"
            
        case .unblockUserAlert:
            return "解除封鎖"
            
        case .deleteMailAlert:
            return "刪除"
            
        case .deleteGrowthCardAlert:
            return "刪除"
            
        case .emptyInputAlert:
            return "無法成功傳送"
            
        case .sendMailAlert:
            return "Vini 將為你寄出信件"
            
        case .updateContentCardAlert:
            return "更新卡片"
            
        }
    }
    
    var message: String {
        
        switch self {
            
        case .reflectionTimeAlert:
            return "反思功能僅在每日反思時段開放，晚點再回來看看吧！"
        case .logOutAlert:
            return "您確定要登出嗎？"
        case .blockUserAlert:
            return "您將不會在 Vini Cloud 及收信匣看到此使用者的內容，您可以隨時在設定頁解除封鎖。"
        case .unblockUserAlert:
            return "您確定要解除封鎖此使用者嗎？"
        case .deleteMailAlert:
            return "您確定要刪除此信件嗎？"
            
        case .deleteGrowthCardAlert:
            return "您確定要刪除此成長卡片嗎？所有微小學習內容將會一併刪除。"
            
        case .emptyInputAlert:
            return "您的輸入內容似乎不完整，請確認完成所有欄位後再嘗試一次！"
            
        case .sendMailAlert:
            return "您確定要寄出此信件嗎？"
            
        case .updateContentCardAlert:
            return "您確定要更新這張卡片嗎？"
        }
    }
    
}
