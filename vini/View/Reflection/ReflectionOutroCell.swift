//
//  ReflectionOutroCell.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/11/3.
//

import UIKit

class ReflectionOutroCell: UICollectionViewCell {

    @IBOutlet weak var cloudImageView: UIImageView!
    
    @IBOutlet weak var continueButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        continueButton.layer.cornerRadius = 23
        
        cloudImageView.float(duration: 1.8)
    }

}
