//
//  CongratsViewController.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/23.
//

import UIKit

class CongratsViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        headerView.setBottomCurve()
        
        backButton.layer.cornerRadius = backButton.frame.height / 2
    }
    
    @IBAction func tapBackButton(_ sender: Any) {
        
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    

}
