//
//  AlertViewController.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/11/7.
//

import UIKit

class AlertViewController: UIViewController {

    @IBOutlet weak var alertView: UIView!
    
    @IBOutlet weak var viniImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    var alertType: Alert?
    
    var viniType = UIImage.AssetIdentifier.alert
    
    var alertStyle: AlertStyle = .normal
    
    var onCancel: (() -> Void)?
    
    var onConfirm: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isModalInPresentation = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupAlert()
        playMediumImpactVibration()
    }
    
    @objc func tapCancelButton(_ sender: UIButton) {
        
        defer {
            
            self.dismiss(animated: true, completion: nil)
        }
        
        let onCancel = self.onCancel

        self.onCancel = nil
        
        guard let block = onCancel else { return }
        
        block()
    }
    
    @objc func tapConfirmButton(_ sender: UIButton) {
        
        defer {
            
            playLightImpactVibration()
            self.dismiss(animated: true, completion: nil)
        }
        
        let onConfirm = self.onConfirm
        
        self.onConfirm = nil
        
        guard let block = onConfirm else { return }
        
        block()
    }
}

extension AlertViewController {
    
    func setupAlert() {
        
        titleLabel.text = alertType?.title
        messageLabel.text = alertType?.message
        
        cancelButton.addTarget(self, action: #selector(tapCancelButton(_:)), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(tapConfirmButton(_:)), for: .touchUpInside)
        
        viniImageView.float(duration: 1.8)
        
        alertView.layer.cornerRadius = 25
        cancelButton.layer.cornerRadius = 18
        confirmButton.layer.cornerRadius = 18
        
        viniImageView.image = UIImage(assetIdentifier: viniType)
        
        switch alertStyle {
            
        case .danger:
            setupDangerAlertAppearance()
            
        default:
            break
            
        }
    }
    
    func setupDangerAlertAppearance() {
        
        viniImageView.isHidden = true
        confirmButton.backgroundColor = UIColor(red: 210/255, green: 13/255, blue: 13/255, alpha: 0.9)
    }
    
}
