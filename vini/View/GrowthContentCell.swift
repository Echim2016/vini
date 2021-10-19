//
//  GrowthContentCell.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/19.
//

import UIKit

class GrowthContentCell: UITableViewCell {

    @IBOutlet weak var cellBackgroundView: UIView!
    
    @IBOutlet weak var growthContentImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
        
        self.selectionStyle = .none
        
        cellBackgroundView.layer.cornerRadius = 25
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
