//
//  Vini.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/26.
//

import UIKit
import Foundation

struct Vini {
    
    var id: String
    var name: String
    var wondering: String
    var viniType: String
    
    init() {
        
        self.id = ""
        self.name = "Vini"
        self.wondering = ""
        self.viniType = "vini_amaze"
    }
}

class ViniView: UIView {
    
    var data: Vini = Vini()

    var viniImageView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupView()
        
        self.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        self.addSubview(viniImageView)
        
        viniImageView.contentMode = .scaleAspectFit
        
        viniImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            viniImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            viniImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            viniImageView.topAnchor.constraint(equalTo: self.topAnchor),
            viniImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
}
