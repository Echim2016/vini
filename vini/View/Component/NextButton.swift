//
//  NextButton.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/11/5.
//

import UIKit

class NextButton: UIButton {
    
    var title = "→"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont(name: "PingFangTC-Medium", size: 18)
        self.setTitleColor(.white, for: .normal)
        self.setTitleColor(.lightGray, for: .highlighted)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupButton()
    }
    
    func setupButton() {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.height / 2
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.05)
    }
}
