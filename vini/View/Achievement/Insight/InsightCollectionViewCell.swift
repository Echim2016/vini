//
//  InsightCollectionViewCell.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/11/2.
//

import UIKit

class InsightCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 18
    }
    
    func setupCell(title: String, data: String) {
        
        titleLabel.text = title
        numberLabel.text = data
    }
    

}
