//
//  DrawConclusionsViewController.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/22.
//

import UIKit
import RSKPlaceholderTextView
import SwiftUI

class DrawConclusionsViewController: UIViewController {

    @IBOutlet weak var conclusionIntroLabel: UILabel!{
        didSet {
            conclusionIntroLabel.text = "關於「\(introText)」..."
        }
    }
        
    @IBOutlet weak var conclusionTextView: RSKPlaceholderTextView! {
        didSet {
            conclusionTextView.delegate = self
        }
    }
    
    var introText = "這張成長卡片"
    var growthCardID = ""
    var conclusionToAdd = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupTextView()
        
        setupNavBar()
        
        fetchConclusion()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        textViewDidEndEditing(conclusionTextView)
        
        GrowthCardProvider.shared.updateConclusion(id: growthCardID, conclusion: conclusionToAdd) { result in
            
            switch result {
            case .success(let success):
                print(success)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func tapBackButton(_ sender: UIBarButtonItem) {
        
        self.navigationController?.popViewController(animated: true)
    }
}

extension DrawConclusionsViewController {
    
    private func fetchConclusion() {
        
        GrowthCardProvider.shared.fetchConclusion(id: growthCardID) { result in
            
            switch result {
            case .success(let conclusion):
                
                self.conclusionToAdd = conclusion
                self.conclusionTextView.text = self.conclusionToAdd
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

// MARK: - Text View -
extension DrawConclusionsViewController: UITextViewDelegate {
    
    func setupTextView() {
        
        conclusionTextView.placeholder = "我有一些結論是..."
        conclusionTextView.tintColor = UIColor.S1
        conclusionTextView.contentInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        guard let text = textView.text,
              !text.isEmpty else {
                  return
              }
        
        switch textView {
        case conclusionTextView:
            conclusionToAdd = text
        default:
            break
        }
    }
}

extension DrawConclusionsViewController {
    
    func setupNavBar() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(tapBackButton(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.B2
    }
}
