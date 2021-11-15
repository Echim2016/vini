//
//  ReflectionPracticeCell.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/11/3.
//

import UIKit

class ReflectionPracticeCell: UICollectionViewCell {

    @IBOutlet weak var question1Label: UILabel!
    @IBOutlet weak var question2Label: UILabel!
    @IBOutlet weak var question3Label: UILabel!
    @IBOutlet weak var cloudImageView: UIImageView!
    @IBOutlet weak var bottomStraightLine: UIView!
    
    weak var delegate: ReflectionViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        question1Label.alpha = 0
        question2Label.alpha = 0
        question3Label.alpha = 0
        bottomStraightLine.alpha = 0
        
    }
    
    func setupCell(quotes: [String]) {
        
        var displayQuotes = quotes
        displayQuotes.shuffle()
        
        question1Label.text = displayQuotes[0]
        question2Label.text = displayQuotes[1]
        question3Label.text = displayQuotes[2]
        
        cloudImageView.float(duration: 1.7)
        
        setupLabel1Animation()
    }
    
    func setupLabel1Animation() {
        
        UIView.animate(
            withDuration: 2,
            delay: 1.5,
            animations: {
                self.question1Label.alpha = 1
//                self.delegate?.collectionView.isScrollEnabled = false
            },
            completion: { _ in
                self.setupLabel2Animation()
            }
        )
    }
    
    func setupLabel2Animation() {
        
        UIView.animate(
            withDuration: 2,
            delay: 2,
            animations: {
                self.question2Label.alpha = 1
            },
            completion: { _ in
                self.setupLabel3Animation()
            }
        )
    }
    
    func setupLabel3Animation() {
        
        UIView.animate(
            withDuration: 2,
            delay: 2,
            animations: {
                self.question3Label.alpha = 1
            },
            completion: { _ in
                
                self.setupBottomLineAnimation()
            }
        )
    }
    
    func setupBottomLineAnimation() {
        
        UIView.animate(
            withDuration: 2,
            delay: 1,
            animations: {
                self.bottomStraightLine.alpha = 1
            },
            completion: { _ in
                
                self.delegate?.collectionView.isScrollEnabled = true
                self.delegate?.isVisited = true
            }
        )
    }

}
