//
//  CreateGrowthContentCell.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/19.
//

import UIKit

class CreateGrowthContentCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var welcomeMessageLabel: UILabel!
    
    @IBOutlet weak var cellBackgroundView: UIView!
    
    @IBOutlet weak var createGrowthContentCardButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
        
        self.selectionStyle = .none
        
        cellBackgroundView.layer.cornerRadius = 25
        
        setupButton()
        
        setCurrentDate()
    }
    
    func setupButton() {
        
        createGrowthContentCardButton.layer.cornerRadius = 25
    }
    
    func setCurrentDate() {
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d"
        dateLabel.text = dateFormatter.string(from: date)
    }
    
    func setupCellForArchivedMode() {
        
        welcomeMessageLabel.text = "歡迎回來，希望你能在此得到新的啟發。"
        createGrowthContentCardButton.isHidden = true
    }
    
}
