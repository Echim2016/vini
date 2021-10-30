//
//  UIViewController+Extension.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/30.
//

import UIKit

extension UIViewController {
    
    func setupNavBarBackButton() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(tapBackBarButtonItem(_:))
        )
        navigationItem.leftBarButtonItem?.tintColor = UIColor.S1
    }
    
    @objc func tapBackBarButtonItem(_ sender: UIBarButtonItem) {
        
        self.navigationController?.popViewController(animated: true)
    }
}
