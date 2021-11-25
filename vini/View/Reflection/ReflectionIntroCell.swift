//
//  ReflectionIntroCell.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/11/3.
//

import UIKit

protocol CollectionViewCellDelegate: AnyObject {
    
    func didTapDismissButton(_ cell: UICollectionViewCell)
}

class ReflectionIntroCell: UICollectionViewCell {
    
    weak var delegate: CollectionViewCellDelegate?

    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var moonImageView: UIImageView!
    @IBOutlet weak var introTitleLabel: UILabel!
    @IBOutlet weak var introContentLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var headphoneIntroStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        introTitleLabel.alpha = 0
        introContentLabel.alpha = 0
        moonImageView.alpha = 0
        headphoneIntroStackView.alpha = 0
        
        dismissButton.addTarget(self, action: #selector(tapDismissButton(_:)), for: .touchUpInside)
        
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
                self.headphoneIntroStackView.alpha = 1
            },
            completion: { _ in
                
                self.headphoneIntroStackView.float(duration: 1.8)
            }
        )
    }
    
    @objc func tapDismissButton(_ sender: UIButton) {
        
        delegate?.didTapDismissButton(self)
    }
}
