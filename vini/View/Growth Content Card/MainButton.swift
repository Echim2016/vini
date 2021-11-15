//
//  MainButton.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/11/10.
//

import UIKit
import Haptica

class MainButton: UIButton {

    override var isHighlighted: Bool {

        didSet {
            itemIsHighlighted()
        }
    }
}
