//
//  UIAction+Extension.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/11/27.
//

import UIKit

extension UIAction {
    
    static func setupAction(of type: ContextMenuAction, handler: @escaping (UIAction) -> Void) -> UIAction {
                
        let action = UIAction(
            title: type.title,
            image: type.image,
            handler: handler
        )
        
        if let attribute = type.attribute {
            
            action.attributes = [attribute]
        }
        
        return action
    }
    
}

enum ContextMenuAction {
    
    case edit
    case delete
    case block
    case unarchive
    
    var title: String {
        
        switch self {
            
        case .edit:
            return "編輯"
        case .delete:
            return "刪除"
        case .block:
            return "封鎖"
        case .unarchive:
            return "解除封存"
        }
    }
    
    var image: UIImage? {
        
        switch self {
            
        case .edit:
            return UIImage(systemName: "square.and.pencil")
        case .delete:
            return UIImage(systemName: "trash.fill")
        case .block:
            return UIImage(systemName: "exclamationmark.bubble.fill")
        case .unarchive:
            return UIImage(systemName: "arrow.uturn.forward")
        }
    }
    
    var attribute: UIMenuElement.Attributes? {
        
        switch self {
            
        case .delete, .block:
            return .destructive
        default:
            return nil
        }
    }
    
}
