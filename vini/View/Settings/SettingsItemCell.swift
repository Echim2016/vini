//
//  SettingsItemCell.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/31.
//

import UIKit

class SettingsItemCell: UITableViewCell {

    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        let layer = CAGradientLayer()
        layer.frame = cellBackgroundView.bounds
        layer.colors = [UIColor.B2.cgColor, UIColor.B1.cgColor]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 2, y: 3)
        self.cellBackgroundView.layer.insertSublayer(layer, at: 0)
    }
    
    func setupCell(title: String){
        
        titleLabel.text = title
    }

}
