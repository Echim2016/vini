//
//  ReflectionIntroCell.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/11/3.
//

import UIKit

class ReflectionIntroCell: UICollectionViewCell {

    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var moonImageView: UIImageView!
    @IBOutlet weak var introTitleLabel: UILabel!
    @IBOutlet weak var introContentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        introTitleLabel.alpha = 0
        introContentLabel.alpha = 0
        moonImageView.alpha = 0
        
    }
    
    func setupTitleAnimation() {
        
        UIView.animate(
            withDuration: 1,
            delay: 0,
            animations: {
                
                self.introTitleLabel.alpha = 1
                self.moonImageView.alpha = 1
            },
            completion: { _ in
                
                self.setupContentAnimation()
            }
        )
    }
    
    func setupContentAnimation() {
        
        UIView.animate(
            withDuration: 1,
            delay: 1,
            animations: {
                
                self.introContentLabel.alpha = 1
            },
            completion: nil
        )
        
    }

}
