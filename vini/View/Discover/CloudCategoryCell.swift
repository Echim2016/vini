//
//  MapCategoryCell.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/11/8.
//

import UIKit

class CloudCategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var mapBackgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var introLabel: UILabel!
    
    @IBOutlet weak var mistImageView: UIImageView!
    
    let gradientLayer = CAGradientLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setupCell(category: CloudCategory) {
        
        titleLabel.text = category.title
        introLabel.text = category.introduction
        
        mistImageView.float(duration: 2.8)
//        UIView.animate(withDuration: 39.6, animations: {
//            self.mistImageView.transform = CGAffineTransform(scaleX: 4, y: 4)
//        })
        
        DispatchQueue.main.async {
            
            self.gradientLayer.frame = self.mapBackgroundView.bounds
            self.gradientLayer.colors = category.colors
            self.gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            self.gradientLayer.endPoint = CGPoint(x: 0, y: 2)
            self.mapBackgroundView.layer.insertSublayer(self.gradientLayer, at: 0)
        }
    }

}
