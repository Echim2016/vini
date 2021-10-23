//
//  KingfisherWrapper.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/19.
//

import UIKit
import Kingfisher

extension UIImageView {

    func loadImage(_ urlString: String?, placeHolder: UIImage? = nil) {

        guard urlString != nil else { return }
        
        let url = URL(string: urlString!)

        self.kf.setImage(with: url, placeholder: placeHolder)
    }
}
