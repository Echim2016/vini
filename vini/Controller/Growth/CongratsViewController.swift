//
//  CongratsViewController.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/23.
//

import UIKit

class CongratsViewController: UIViewController {

    weak var growthPageVC: GrowthPageViewController?
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var vini: UIImageView!
    
    @IBOutlet weak var congratsMessages: UIStackView!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        headerView.setBottomCurve()
        
        backButton.layer.cornerRadius = backButton.frame.height / 2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showVini()
        
    }
    
    @IBAction func tapBackButton(_ sender: Any) {
     
        growthPageVC?.fetchGrowthCards()
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}

extension CongratsViewController {
    
    func showVini() {
        
        UIView.animate(
            withDuration: 1.5,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                
                self.vini.alpha = 1.0
            },
            completion: { _ in
                self.fadeInHeaderView()
            })
    }
    
    func fadeInHeaderView() {
        
        UIView.animate(
            withDuration: 0.6,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                
                self.headerView.alpha = 1.0
                self.headerViewHeight.constant = self.view.frame.height / 3
                self.view.layoutIfNeeded()
                self.headerView.setBottomCurve()
            },
            completion: { _ in
                self.fadeInMessages()
                self.floatVini()
            })
        
    }
    
    func fadeInMessages() {
        
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                
                self.congratsMessages.alpha = 1.0
                self.backButton.alpha = 1.0
            })
    }
    
    func floatVini() {
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: [.autoreverse, .repeat],
            animations: {
                self.vini.frame = CGRect(
                    x: self.vini.frame.origin.x,
                    y: self.vini.frame.origin.y - 10,
                    width: self.vini.frame.size.width,
                    height: self.vini.frame.size.height)
            },
            completion: nil
        )
        
    }
    
}
