//
//  UIStoryboard+Extension.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/11/7.
//

import UIKit

enum StoryboardCategory: String {
    
    case main = "Main"
    
    case signIn = "SignIn"
    
    case signUp = "SignUp"
    
    case growthCapture = "GrowthCapture"
    
    case timePicker = "TimePicker"
    
    case reflection = "Reflection"
}

extension UIStoryboard {
    
    static var main = UIStoryboard(name: StoryboardCategory.main.rawValue, bundle: nil)
    
    static var signIn = UIStoryboard(name: StoryboardCategory.signIn.rawValue, bundle: nil)
    
    static var signUp = UIStoryboard(name: StoryboardCategory.signUp.rawValue, bundle: nil)

    static var growthCapture = UIStoryboard(name: StoryboardCategory.growthCapture.rawValue, bundle: nil)
    
    static var timePicker = UIStoryboard(name: StoryboardCategory.timePicker.rawValue, bundle: nil)
    
    static var reflection = UIStoryboard(name: StoryboardCategory.reflection.rawValue, bundle: nil)
}
