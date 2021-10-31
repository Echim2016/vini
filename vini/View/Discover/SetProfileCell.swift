//
//  SetWonderingCell.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/27.
//

import UIKit
import RSKPlaceholderTextView

class SetProfileCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: RSKPlaceholderTextView!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(title: String, placeholder: String) {
        
        titleLabel.text = title
        textView.placeholder = NSString(utf8String: placeholder)
        textView.tintColor = UIColor.S1
        textView.contentInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
    }
    
    func setTextViewHeight(height: CGFloat) {
        
        textViewHeight.constant = height
        self.layoutIfNeeded()
    }
    
}
