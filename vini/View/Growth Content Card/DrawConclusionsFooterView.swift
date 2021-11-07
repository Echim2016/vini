//
//  DrawConclusionsFooterView.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/21.
//

import UIKit

class DrawConclusionsFooterView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setupView()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension DrawConclusionsFooterView {
    
    func setupView() {
        
        backgroundColor = UIColor.S1
        
    }
}
