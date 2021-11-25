//
//  MailContentCell.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/30.
//

import UIKit

class MailContentCell: UITableViewCell {

    @IBOutlet weak var contentTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
        
        self.selectionStyle = .none
        
        self.contentTextView.isScrollEnabled = false
    }

    func setupCell(content: String) {
        
        contentTextView.text = content
    }
}
