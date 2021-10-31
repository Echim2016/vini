//
//  AchievementViewController.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/29.
//

import UIKit

class AchievementViewController: UIViewController {

    @IBOutlet weak var waveView: UIView!
    @IBOutlet weak var viniImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        waveView.showWaveAnimation()
        waveView.float(duration: 0.5)
        waveView.bringSubviewToFront(viniImageView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        waveView.clearAnimation()
    }

}
