//
//  MailCell.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/29.
//

import UIKit

class MailCell: UITableViewCell {

    @IBOutlet weak var viniImageView: UIImageView!
    @IBOutlet weak var labelStackView: UIStackView!
    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var mailTitleLabel: UILabel!
    @IBOutlet weak var cellMaskView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func setupCell(senderName: String, title: String, image: String) {
        
        senderNameLabel.text = senderName
        mailTitleLabel.text = title
        
        let types = UIImage.AssetIdentifier.allCases.map { $0.name }
        let imageIndex = types.firstIndex(of: image) ?? 0
        let viniImage = UIImage.AssetIdentifier(rawValue: imageIndex) ?? UIImage.AssetIdentifier.amaze
        
        viniImageView.image = UIImage.init(assetIdentifier: viniImage)
        
        cellMaskView.alpha = 0
    }
    
    func setupDetailCellAppearance() {
     
        mailTitleLabel.font = UIFont(name: "PingFangTC-medium", size: 12)
        mailTitleLabel.textColor = .gray
    }
    
    func setupReadAppearance() {
        
        mailTitleLabel.textColor = .G1
    }
    
    func setupMask() {
        
        cellMaskView.alpha = 1
        
        cellMaskView.layer.cornerRadius = labelStackView.frame.height / 2
        
        let introLabel = UILabel()
        
        introLabel.font = UIFont(name: "PingFangTC-Medium", size: 16)
        introLabel.textColor = .B1
        introLabel.text = "這是一則新信件，請於睡前反思期間回來查看！"
        introLabel.numberOfLines = 0
        introLabel.lineBreakMode = .byWordWrapping
        
        cellMaskView.addSubview(introLabel)
        
        introLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            introLabel.leadingAnchor.constraint(equalTo: cellMaskView.leadingAnchor, constant: 16),
            introLabel.trailingAnchor.constraint(equalTo: cellMaskView.trailingAnchor, constant: -16),
            introLabel.topAnchor.constraint(equalTo: cellMaskView.topAnchor, constant: 8),
            introLabel.bottomAnchor.constraint(equalTo: cellMaskView.bottomAnchor, constant: -8)
        ])
        
        self.layoutIfNeeded()
    }
    
}
