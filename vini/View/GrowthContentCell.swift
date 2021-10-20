//
//  GrowthContentCell.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/19.
//

import UIKit

class GrowthContentCell: UITableViewCell {

    @IBOutlet weak var cellBackgroundView: UIView!
    
    @IBOutlet weak var growthContentImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var createdTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .B1
        
        self.selectionStyle = .none
        
        cellBackgroundView.layer.cornerRadius = 25
        
        growthContentImageView.layer.cornerRadius = 18
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(content: GrowthContent) {
        
        titleLabel.text = content.title
        
        contentLabel.text = content.content
        
        growthContentImageView.isHidden = content.image.isEmpty ? true : false
        
        growthContentImageView.loadImage(content.image, placeHolder: nil)
        
        let timeInterval = TimeInterval(Int(content.createdTime.seconds))
        
        let dformatter = DateFormatter()
        
        dformatter.dateFormat = "yyyy/MM/dd"
        
        createdTimeLabel.text = "\(dformatter.string(from: Date(timeIntervalSince1970: timeInterval)))"
        
    }
}
