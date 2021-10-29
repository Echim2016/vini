//
//  MailCell.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/29.
//

import UIKit

class MailCell: UITableViewCell {

    @IBOutlet weak var viniImageView: UIImageView!
    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var mailTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(senderName: String, title: String, image: String) {
        
        senderNameLabel.text = senderName
        mailTitleLabel.text = "回覆：" + title
        
        let types = UIImage.AssetIdentifier.allCases.map { $0.name }
        let imageIndex = types.firstIndex(of: image) ?? 0
        let viniImage = UIImage.AssetIdentifier(rawValue: imageIndex) ?? UIImage.AssetIdentifier.amaze
        
        viniImageView.image = UIImage.init(assetIdentifier: viniImage)
    }
    
}
