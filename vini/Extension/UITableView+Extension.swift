//
//  UITableView+Extension.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/18.
//

import UIKit

extension UITableView {

    func registerCellWithNib(identifier: String, bundle: Bundle?) {

        let nib = UINib(nibName: identifier, bundle: bundle)

        register(nib, forCellReuseIdentifier: identifier)
    }

    func registerHeaderWithNib(identifier: String, bundle: Bundle?) {

        let nib = UINib(nibName: identifier, bundle: bundle)

        register(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }
}

extension UITableViewCell {
    
    static var identifier: String {
        
        return String(describing: self)
    }
    
}

extension UITableViewHeaderFooterView {
    
    static var identifier: String {
        
        return String(describing: self)
    }
}
