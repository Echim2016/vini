//
//  UIView+Extension.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/19.
//

import UIKit

extension UIView {
    
    func addTopRoundedCornerToView(targetView: UIView?, desiredCurve: CGFloat?) {
        
        let offset: CGFloat =  targetView!.frame.width / desiredCurve!
        let bounds: CGRect = targetView!.bounds
        
        // Top side curve
        let rectBounds: CGRect = CGRect(x: bounds.origin.x, y: bounds.origin.y+bounds.size.height / 2, width: bounds.size.width, height: bounds.size.height / 2)
        
        let rectPath: UIBezierPath = UIBezierPath(rect: rectBounds)
        
        // Top side curve
        let ovalBounds: CGRect = CGRect(x: bounds.origin.x - offset / 2, y: bounds.origin.y, width: bounds.size.width + offset, height: bounds.size.height)
        
        let ovalPath: UIBezierPath = UIBezierPath(ovalIn: ovalBounds)
        rectPath.append(ovalPath)
        
        // Create the shape layer and set its path
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = rectPath.cgPath
        
        // Set the newly created shape layer as the mask for the view's layer
        targetView!.layer.mask = maskLayer
    }
    
    func setTopCurve() {
        let offset = CGFloat(self.frame.size.height / 2)
        let bounds = self.bounds
        let rectBounds = CGRect(x: bounds.origin.x, y: bounds.origin.y + bounds.size.height / 2, width: bounds.size.width * 1.1, height: bounds.size.height / 2)
        
        let rectPath = UIBezierPath(rect: rectBounds)
        
        let ovalBounds = CGRect(x: bounds.origin.x - offset / 2, y: bounds.origin.y + offset * 0.2, width: bounds.size.width + offset, height: bounds.size.height * 0.6)
        let ovalPath = UIBezierPath(ovalIn: ovalBounds)
        rectPath.append(ovalPath)
        
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = bounds
        maskLayer.path = rectPath.cgPath
        self.layer.mask = maskLayer
    }
    
    func addBottomRoundedCornerToView(targetView: UIView?, desiredCurve: CGFloat?) {
        
        let offset: CGFloat =  targetView!.frame.width / desiredCurve!
        let bounds: CGRect = targetView!.bounds
        
        // Bottom side curve
        let rectBounds: CGRect = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.size.width, height: bounds.size.height / 2)
        
        let rectPath: UIBezierPath = UIBezierPath(rect: rectBounds)
        
        // Bottom side curve
        let ovalBounds: CGRect = CGRect(x: bounds.origin.x - offset / 2, y: bounds.origin.y, width: bounds.size.width + offset, height: bounds.size.height)
        
        let ovalPath: UIBezierPath = UIBezierPath(ovalIn: ovalBounds)
        rectPath.append(ovalPath)
        
        // Create the shape layer and set its path
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = rectPath.cgPath
        
        // Set the newly created shape layer as the mask for the view's layer
        targetView!.layer.mask = maskLayer
    }
    
    func setBottomCurve() {
        
        let offset = CGFloat(self.frame.size.height / 3)
        let bounds = self.bounds
        
        let rectBounds = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.size.width * 1.1, height: bounds.size.height / 2)
        let rectPath = UIBezierPath(rect: rectBounds)
        let ovalBounds = CGRect(x: bounds.origin.x - offset / 2, y: bounds.origin.y, width: bounds.size.width + offset, height: bounds.size.height)
        
        let ovalPath = UIBezierPath(ovalIn: ovalBounds)
        rectPath.append(ovalPath)
        
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = bounds
        maskLayer.path = rectPath.cgPath
        self.layer.mask = maskLayer
    }
    
}

public extension UIView {

    func shake(count: Float = 10, for duration: TimeInterval = 2, withTranslation translation: Float = 3) {

        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.repeatCount = count
        animation.duration = duration/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.values = [translation, -translation]
        layer.add(animation, forKey: "shake")
    }
}