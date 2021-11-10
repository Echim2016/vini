//
//  BlockUserCell.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/11/9.
//

import UIKit

protocol BlockUserProtocol: AnyObject {
    
    func didTapUnblockButton(_ cell: BlockUserCell)
}

class BlockUserCell: UITableViewCell {

    @IBOutlet weak var blockUserName: UILabel!
    @IBOutlet weak var unblockButton: UIButton!
    
    weak var delegate: BlockUserProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        unblockButton.addTarget(self, action: #selector(tapUnlockButton(_:)), for: .touchUpInside)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        unblockButton.layer.cornerRadius = unblockButton.frame.size.height / 2
    }
    
    func setupCell(user: User) {
        
        blockUserName.text = user.displayName
    }
    
    @objc func tapUnlockButton(_ sender: UIButton) {
        
        delegate?.didTapUnblockButton(self)
    }
}

