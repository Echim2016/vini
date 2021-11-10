//
//  UIButton+Extension.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/11/10.
//

import UIKit

extension UIButton {
    
    func itemIsHighlighted() {
        
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: [.curveEaseOut],
            animations: {
                self.alpha = self.isHighlighted ? 0.9 : 1.0
                self.transform = self.isHighlighted ?
                CGAffineTransform.identity.scaledBy(x: 0.97, y: 0.97) : CGAffineTransform.identity
        })
    }
}
