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
    
    let privacyURL = "https://www.privacypolicies.com/live/e5082ad3-aa9c-4307-9329-d5d333917e4b"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupWebView()
        setupNavBarBackButton()
        setupNavigationController(title: "隱私權政策", titleColor: .white)
    }
    
    func setupWebView() {
        
        guard let url = URL(string: privacyURL) else {
            VProgressHUD.showFailure()
            return
        }
        
        webView.load(URLRequest(url: url))
    }

}
