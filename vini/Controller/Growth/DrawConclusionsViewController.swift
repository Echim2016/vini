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
            
            if let growthCard = growthCard {
                
                conclusionIntroLabel.text = "關於「\(growthCard.title)」..."
            }
        }
    }
        
    @IBOutlet weak var conclusionTextView: RSKPlaceholderTextView! {
        
        didSet {
            
            conclusionTextView.delegate = self
        }
    }
    
    let manager = GrowthCardManager.shared
    var growthCard: GrowthCard?
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
        
        if let id = growthCard?.id {
            
            manager.fetchConclusion(id: id) { result in
                
                switch result {
                    
                case .success(let conclusion):
                    
                    self.growthCard?.conclusion = conclusion
                    self.conclusionTextView.text = conclusion
                    
                case .failure(let error):
                    
                    print(error)
                }
            }
            
        } else {
            
            VProgressHUD.showFailure(text: "似乎出了一點問題，請再試一次")
            navigationController?.popViewController(animated: true)
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
            
            growthCard?.conclusion = text
            
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
            
            guard let growthCard = growthCard else {
                
                VProgressHUD.showFailure()
                return
            }
            
            manager.updateConclusion(growthCard: growthCard) { result in
                
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
