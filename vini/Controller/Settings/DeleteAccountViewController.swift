//
//  DeleteAccountViewController.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2022/6/25.
//

import UIKit

class DeleteAccountViewController: UIViewController {

    @IBOutlet weak var viniImageView: UIImageView!
    
    @IBOutlet weak var cancelButton: MainButton!
    @IBOutlet weak var confirmButton: MainButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPopGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationController(title: "刪除帳號", titleColor: .white)
        setupNavBarBackButton()
        setupUI()
    }
    
    deinit {
        viniImageView.layer.removeAllAnimations()
    }
    
    func setupUI() {
        viniImageView.float(duration: 1.8)
        
        cancelButton.addTarget(self, action: #selector(tapCancelButton(_:)), for: .touchUpInside)
        cancelButton.layer.cornerRadius = 25
        confirmButton.layer.cornerRadius = 25
    }
    
    @objc func tapCancelButton(_ sender: UIButton) {
            
        self.navigationController?.popViewController(animated: true)
    }
}
