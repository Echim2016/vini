//
//  PrivacyPolicyViewController.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/11/12.
//

import UIKit
import WebKit

class PrivacyPolicyViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupWebView()
        setupNavBarBackButton()
        setupPopGestureRecognizer()
        setupNavigationController(title: "隱私權政策", titleColor: .white)
    }
    
    func setupWebView() {
        
        guard let privacyURL = Bundle.main.infoDictionary?["PrivacyURL"] as? String,
              let url = URL(string: privacyURL) else {
            
            VProgressHUD.showFailure()
            navigationController?.popViewController(animated: true)
            return
        }
        
        webView.load(URLRequest(url: url))
    }

}
