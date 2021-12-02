//
//  TitleHeaderView.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/11/26.
//

import UIKit

class TitleHeaderView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupHeaderView(backgroundColor: UIColor = .clear, textColor: UIColor, fontSize: CGFloat, text: String) {
        
        self.backgroundColor = backgroundColor
        
        let titleLabel = UILabel()
        titleLabel.text = text
        titleLabel.textColor = textColor
        titleLabel.font = UIFont(name: "PingFangTC-Semibold", size: fontSize)
        
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16)
        ])
    }
    
}
