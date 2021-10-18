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
        // Initialization code
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
