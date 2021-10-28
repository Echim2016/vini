//
//  CreateGrowthContentCell.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/19.
//

import UIKit

class CreateGrowthContentCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var cellBackgroundView: UIView!
    
    @IBOutlet weak var createGrowthContentCardButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
        
        self.selectionStyle = .none
        
        cellBackgroundView.layer.cornerRadius = 25
        
        createGrowthContentCardButton.layer.cornerRadius = 25
        
        setCurrentDate()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setCurrentDate() {
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d"
        dateLabel.text = dateFormatter.string(from: date)
    }
    
}
