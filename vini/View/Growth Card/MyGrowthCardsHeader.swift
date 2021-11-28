//
//  MyGrowthCardsHeader.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/18.
//

import UIKit

class MyGrowthCardsHeader: UITableViewHeaderFooterView {

    let titleLabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContents() {
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleLabel)
        
        contentView.backgroundColor = UIColor(red: 23/255, green: 31/255, blue: 42/255, alpha: 1)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        titleLabel.font = UIFont(name: "PingFangTC-Medium", size: 30)
        
        titleLabel.textColor = .white
    }
    
}
