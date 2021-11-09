//
//  SetCloudCategoryCell.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/11/9.
//

import UIKit

class SetCloudCategoryCell: UITableViewCell {

    @IBOutlet weak var categoryTitleLabel: UILabel!
    
    @IBOutlet weak var checkmarkButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setupCell(title: String, isChecked: Bool) {
        
        categoryTitleLabel.text = title
        categoryTitleLabel.textColor = isChecked ? .white : UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
        checkmarkButton.isHidden = !isChecked
    }
    
}
