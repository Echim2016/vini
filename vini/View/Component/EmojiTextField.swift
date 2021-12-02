//
//  EmojiTextField.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/22.
//

import UIKit

class EmojiTextField: UITextField {

    override var textInputContextIdentifier: String? { "" }
    
    override var textInputMode: UITextInputMode? {
        
        for mode in UITextInputMode.activeInputModes where mode.primaryLanguage == "emoji" {
            
            return mode
        }
        
        return nil
    }
}
