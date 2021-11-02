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
    @IBOutlet weak var cellBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 18
        
        let layer = CAGradientLayer()
        layer.frame = self.cellBackgroundView.bounds
        layer.colors = [
            UIColor.B2.cgColor,
            UIColor.B1.cgColor
        ]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 2, y: 1)
        self.cellBackgroundView.layer.insertSublayer(layer, at: 0)
        
        self.isUserInteractionEnabled = false
    }
    
    func setupCell(title: String, data: String) {
        
        titleLabel.text = title
        numberLabel.text = data
    }
    
}
