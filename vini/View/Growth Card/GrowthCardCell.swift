//
//  GrowthCardCell.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/18.
//

import UIKit

class GrowthCardCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var emojiBackgroundView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var cellBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.backgroundColor = .B1
        self.selectionStyle = .none

        let layer = CAGradientLayer()
        layer.frame = cellBackgroundView.bounds
        layer.colors = [UIColor.B2.cgColor, UIColor.S1.cgColor]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 9, y: 4)
        self.cellBackgroundView.layer.insertSublayer(layer, at: 0)
    }

    func setupCell(title: String, emoji: String) {
        
        titleLabel.text = title
        
        emojiLabel.text = emoji
        
        emojiBackgroundView.layer.cornerRadius = 18
        
        cellBackgroundView.layer.cornerRadius = 25
        
        self.backgroundColor = .clear
        
        self.selectionStyle = .none
        
    }
    
}
