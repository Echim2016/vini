//
//  Vini.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/26.
//

import UIKit
import Foundation

class Vini: UIView {
    
    lazy var name: String = "Vini"
    
    lazy var wondering: String = ""
    
    lazy var viniType: String = ""
    
    lazy var viniImageView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupView()
        
        self.isUserInteractionEnabled = false
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
//
//        self.viniImageView.addGestureRecognizer(tapGesture)
//
//        self.viniImageView.isUserInteractionEnabled = true
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func onTap(_ gesture: UIGestureRecognizer) {
        
        print("tap")
    
    }
    
    private func setupView() {
        
       
        self.addSubview(viniImageView)
        
        viniImageView.contentMode = .scaleAspectFit
        
        viniImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            viniImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            viniImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            viniImageView.widthAnchor.constraint(equalToConstant: 80),
            viniImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
}
