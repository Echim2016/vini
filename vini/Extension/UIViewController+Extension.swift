//
//  UIViewController+Extension.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/30.
//

import UIKit

extension UIViewController {
    
    func setupNavBarBackButton() {
        
        if #available(iOS 14, *) {
        
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "chevron.backward"),
                style: .done,
                target: self,
                action: #selector(tapBackBarButtonItem(_:))
            )
            
        } else {
            
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                title: "←",
                style: .done,
                target: self,
                action: #selector(tapBackBarButtonItem(_:))
            )
        }
        
        navigationItem.leftBarButtonItem?.tintColor = UIColor.lightGray
    }
    
    @objc func tapBackBarButtonItem(_ sender: UIBarButtonItem) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupNavigationController(title: String, titleColor: UIColor) {
        
        let titleLabel = UILabel()
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont(name: "PingFangTC-SemiBold", size: 20) ?? UIFont.systemFont(ofSize: 20),
            NSAttributedString.Key.foregroundColor: titleColor,
            NSAttributedString.Key.kern: 3.0
        ]
        
        titleLabel.attributedText = NSAttributedString(string: title, attributes: attributes)
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel

        self.navigationController?.navigationBar.layoutIfNeeded()
    }
    
    func setupBlurBackground(layer: Int) {
        
        view.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurView, at: layer)
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
}
