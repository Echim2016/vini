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
    @IBOutlet weak var archivedTimeLabel: UILabel!
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var rightArrowButton: UIButton! {
        didSet {
            rightArrowButton.titleLabel?.font = UIFont.systemFont(ofSize: 31)
            rightArrowButton.setTitle("→", for: .normal)
            rightArrowButton.setTitle("→", for: .selected)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 25
        self.rightArrowButton.layer.cornerRadius = 25
        
        let layer = CAGradientLayer()
        layer.frame = self.cellBackgroundView.bounds
        layer.colors = [UIColor.B2.cgColor, UIColor.S1.cgColor]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 15, y: 4)
        self.cellBackgroundView.layer.insertSublayer(layer, at: 0)
    }
    
    func setupCell(growthCard: GrowthCard, index: Int) {
        
        conclusionTextView.text = growthCard.conclusion
        growthCardTitleLabel.text = growthCard.title
        archivedTimeLabel.text = growthCard.archivedTime?.toString(format: .ymdFormat)
        
        rightArrowButton.tag = index
    }
    
    override var isHighlighted: Bool {
        
        didSet {
            toggleIsHighlighted()
        }
    }

}
