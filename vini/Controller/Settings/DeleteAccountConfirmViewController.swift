//
//  DeleteAccountConfirmViewController.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2022/6/25.
//

import UIKit

class DeleteAccountConfirmViewController: UIViewController {
    
    private let deleteConfirmString: String = "bye-vini"
    
    private let vStackView: UIStackView = {
        let vStackView = UIStackView()
        vStackView.axis = .vertical
        vStackView.distribution = .fill
        vStackView.spacing = 16
        return vStackView
    }()
    
    private let remindTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = false
        textView.font = UIFont(name: "PingFangTC-Medium", size: 14)
        textView.textColor = .white
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        return textView
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: "PingFangTC-Medium", size: 24)
        textField.textAlignment = .center
        textField.textColor = .S1
        textField.tintColor = .S1
        textField.setLeftPaddingPoints(16)
        textField.setRightPaddingPoints(16)
        textField.backgroundColor = .white.withAlphaComponent(0.05)
        return textField
    }()
    
    private let confirmButton: MainButton = {
        let button = MainButton()
        button.setTitle("確認永久刪除", for: .normal)
        button.titleLabel?.font = UIFont(name: "PingFangTC-Medium", size: 16)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        button.isEnabled = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPopGestureRecognizer()
        setupUI()
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        confirmButton.addTarget(self, action: #selector(tapConfirmButton), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationController(title: "確認刪除帳號", titleColor: .white)
        setupNavBarBackButton()
        textField.layer.cornerRadius = 10
        confirmButton.layer.cornerRadius = 25
    }
    
    private func setupUI() {
        
        remindTextView.text = "刪除帳號是無法復原的動作，你將會永遠刪除 Vini 中的所有紀錄，請輸入「\(deleteConfirmString)」來確認刪除動作。"
        
        self.view.addSubview(vStackView)
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            vStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            vStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32)
        ])
        
        vStackView.addArrangedSubview(remindTextView)
        remindTextView.translatesAutoresizingMaskIntoConstraints = false
        
        vStackView.addArrangedSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        vStackView.addArrangedSubview(confirmButton)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            confirmButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func tapConfirmButton() {
        
        performUserDeletion()
    }
    
    private func performUserDeletion() {
        
        VProgressHUD.show()
        
        UserManager.shared.deleteUser { result in
            switch result {
            case .success(let isDeleted):
                
                if isDeleted {
                    
                    VProgressHUD.showSuccess()
                    
                    if let signinNav = UIStoryboard.signIn.instantiateViewController(
                        withIdentifier: StoryboardCategory.signIn.rawValue
                    ) as? UINavigationController {
                        
                        if let sceneDelegate: SceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                            sceneDelegate.window?.rootViewController = signinNav
                            sceneDelegate.window?.makeKeyAndVisible()
                        }
                    }
                }
                
            case.failure(let error):
                
                print(error)
                VProgressHUD.showFailure(text: "刪除帳號時出了一點問題，建議重新登入後再試")
            }
        }
    }
}

extension DeleteAccountConfirmViewController {
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        let isCorrectConfirmStringInput: Bool = textField.text == deleteConfirmString
        
        confirmButton.isEnabled = isCorrectConfirmStringInput
        confirmButton.backgroundColor = isCorrectConfirmStringInput ? UIColor(red: 210/255, green: 13/255, blue: 13/255, alpha: 0.9) : UIColor.white.withAlphaComponent(0.3)
    }
}
