//
//  BlockUserCell.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/11/9.
//

import UIKit

class BlockUserCell: UITableViewCell {

    @IBOutlet weak var blockUserName: UILabel!
    @IBOutlet weak var unblockButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        unblockButton.layer.cornerRadius = unblockButton.frame.size.height / 2
    }
    
    func setupCell(user: User) {
        
        blockUserName.text = user.displayName
    }
}
