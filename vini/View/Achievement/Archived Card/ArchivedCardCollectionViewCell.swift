//
//  ArchivedCardCollectionViewCell.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/11/2.
//

import UIKit

class ArchivedCardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var conclusionTextView: UITextView!
    
    @IBOutlet weak var growthCardTitleLabel: UILabel!
    
    @IBOutlet weak var dataLabel: UILabel!
    
    @IBOutlet weak var rightArrowButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 25
        
        self.rightArrowButton.layer.cornerRadius = 25
    }

}
