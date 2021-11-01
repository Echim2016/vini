//
//  MailTitleCell.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/30.
//

import UIKit

class MailTitleCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        self.backgroundColor = .clear
    }

    func setupCell(title: String) {
        
        titleLabel.text = title
    }
}
