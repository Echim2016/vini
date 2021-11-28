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
    
    private enum Segue: String {
        
        case showReturnToPreviousPageAlert = "ShowReturnToPreviousPageAlert"
    }

    @IBOutlet weak var conclusionIntroLabel: UILabel! {
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
    var conclusionHasEdited  = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPopGestureRecognizer()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupTextView()
        setupNavBarBackButton(tintColor: .white)
        setupSaveButton()
        setupNavigationController(title: "我的學習結論", titleColor: .white)
        fetchConclusion()
        setupNavigationBarStandardAppearance(backgroundColor: .B1)
        setupNavigationBarScrollEdgeAppearance(backgroundColor: .B1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        conclusionTextView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        setupNavigationBarScrollEdgeAppearance(backgroundColor: .S2)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let alert = segue.destination as? AlertViewController {
            
            alert.alertType = .returnToPreviousPageAlert
            
            alert.onConfirm = { [weak self] in
                
                guard let self = self else { return }
                
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension DrawConclusionsViewController {
    
    private func fetchConclusion() {
        
        GrowthCardManager.shared.fetchConclusion(id: growthCardID) { result in
            
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
        conclusionTextView.contentInset = UIEdgeInsets(top: 0, left: -2, bottom: 0, right: 0)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        conclusionHasEdited = true
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
    
    override func tapBackBarButtonItem(_ sender: UIBarButtonItem) {
        
        if conclusionHasEdited {

            performSegue(withIdentifier: Segue.showReturnToPreviousPageAlert.rawValue, sender: nil)
            
        } else {
            
            navigationController?.popViewController(animated: true)
        }
    }
    
    func setupSaveButton() {
      
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "checkmark"),
            style: .done,
            target: self,
            action: #selector(tapSaveButton(_:))
        )
        
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    @objc func tapSaveButton(_ sender: Any) {
        
        if conclusionHasEdited {
            
            textViewDidEndEditing(conclusionTextView)
            
            VProgressHUD.show()
            
            GrowthCardManager.shared.updateConclusion(id: growthCardID, conclusion: conclusionToAdd) { result in
                
                switch result {
                case .success(let success):
                    print(success)
                    VProgressHUD.showSuccess(text: "成功儲存")
                    self.conclusionHasEdited = false
                case .failure(let error):
                    print(error)
                    VProgressHUD.showFailure(text: "儲存時出了一些問題，請重新再試")
                }
            }
        } else {
            
            VProgressHUD.showSuccess()
        }
    }
    
}
