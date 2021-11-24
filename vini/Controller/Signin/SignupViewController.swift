//
//  SignupViewController.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/11/4.
//

import UIKit
import UserNotifications
import RSKPlaceholderTextView

class SignupViewController: UIViewController {
    
    var signupBackgoundView: UIView?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameTextView: RSKPlaceholderTextView! {
        didSet {
            nameTextView.delegate = self
        }
    }
    @IBOutlet weak var remindsLabel: UILabel!
    
    @IBOutlet weak var charactersLimitLabel: UILabel!
    
    var nextButton = NextButton()
    
    var notificationButton = NextButton()
    
    var startButton = NextButton()
    
    var displayNameToUpdate = ""
    
    let displayNameCharactersLimit = 10

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupBackgroundView()
        setupTextView()
        setupNextButton()
        setupNotificationButton()
        setupStartButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showContentAnimation()
    }
    
    @objc func tapNextButton(_ sender: UIButton) {
        
        view.endEditing(true)
        
        if !displayNameToUpdate.isEmpty {
            
            updateDisplayName { sucesss in
                if sucesss {
                    self.hideContentAnimation()
                } else {
                    self.nameTextView.text = ""
                    self.nameTextView.shake(count: 5, for: 0.2, withTranslation: 2)
                }
            }
        } else {
            
            self.nameTextView.shake(count: 5, for: 0.3, withTranslation: 3)
        }
       
    }
    
    @objc func tapNotificationButton(_ sender: UIButton) {
        
        askForNotificationAuthorization()
    }
    
    @objc func tapStartButton(_ sender: UIButton) {
        
        redirectToHomePage()
    }
}

extension SignupViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        guard let text = textView.text,
              !text.isEmpty else {
                  textView.text = ""
                  return
              }
        
        self.displayNameToUpdate = text
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText = textView.text ?? ""

        guard let stringRange = Range(range, in: currentText) else { return false }

        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)

        let count = updatedText.count < displayNameCharactersLimit ? updatedText.count : displayNameCharactersLimit
        
        charactersLimitLabel.text = "\(count) / \(displayNameCharactersLimit)"
        
        return updatedText.count <= displayNameCharactersLimit
    }
    
}

extension SignupViewController {
    
    func updateDisplayName(completion: @escaping (Bool) -> Void) {
        
        if let userID = UserManager.shared.userID {
            
            UserManager.shared.updateReflectionTime(
                userID: userID,
                name: displayNameToUpdate) { result in
                    switch result {
                    case .success(_):
                        completion(true)
                    case .failure(let error):
                        print(error)
                        completion(false)
                    }
                }
        } else {
            
            completion(false)
        }
        
    }

}

extension SignupViewController {
    
    func setupBackgroundView() {
        
        let layer = CAGradientLayer()
        layer.frame = self.view.bounds
        layer.colors = [
            UIColor(red: 248/255, green: 129/255, blue: 117/255, alpha: 1.0).cgColor,
            UIColor(red: 85/255, green: 80/255, blue: 126/255, alpha: 1.0).cgColor,
            UIColor.B1.cgColor
        ]
        layer.startPoint = CGPoint(x: 200, y: 0)
        layer.endPoint = CGPoint(x: 200, y: 1)
        self.view.layer.insertSublayer(layer, at: 0)
        
        titleLabel.alpha = 0
        nameTextView.alpha = 0
        remindsLabel.alpha = 0
        nextButton.alpha = 0
    }
    
    func setupTextView() {
    
        nameTextView.layer.cornerRadius = 10
        nameTextView.tintColor = UIColor.white
        nameTextView.textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 0, right: 0)
        nameTextView.textContainer.maximumNumberOfLines = 1
        charactersLimitLabel.text = "\(nameTextView.text.count) / \(displayNameCharactersLimit)"
    }
    
    func setupNextButton() {
        
        nextButton.addTarget(self, action: #selector(tapNextButton(_:)), for: .touchUpInside)
        
        view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nextButton.widthAnchor.constraint(equalToConstant: 60),
            nextButton.heightAnchor.constraint(equalToConstant: 40),
            nextButton.topAnchor.constraint(equalTo: remindsLabel.bottomAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: nameTextView.trailingAnchor, constant: 0)
        ])
    }
    
    func setupNotificationButton() {
        
        notificationButton.addTarget(self, action: #selector(tapNotificationButton(_:)), for: .touchUpInside)
        
        view.addSubview(notificationButton)
        notificationButton.setTitle("開始設定", for: .normal)
        notificationButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            notificationButton.widthAnchor.constraint(equalToConstant: 200),
            notificationButton.heightAnchor.constraint(equalToConstant: 40),
            notificationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            notificationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
                
        notificationButton.alpha = 0
    }
    
    func setupStartButton() {
        
        startButton.addTarget(self, action: #selector(tapStartButton(_:)), for: .touchUpInside)
        
        view.addSubview(startButton)
        startButton.setTitle("開始成長", for: .normal)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            startButton.widthAnchor.constraint(equalToConstant: 200),
            startButton.heightAnchor.constraint(equalToConstant: 40),
            startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
                
        startButton.alpha = 0
    }
    
    func showContentAnimation() {
        
        UIView.animate(
            withDuration: 1.0,
            delay: 0.1,
            options: .curveEaseInOut,
            animations: {
                self.titleLabel.alpha = 1
                self.nameTextView.alpha = 1
                self.remindsLabel.alpha = 1
                self.nextButton.alpha = 1
                self.nameTextView.becomeFirstResponder()
            },
            completion: nil
        )
    }
    
    func hideContentAnimation() {
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0.1,
            options: .curveEaseInOut,
            animations: {
                self.titleLabel.frame.origin.y -= 30
                self.nameTextView.frame.origin.y -= 30
                self.remindsLabel.frame.origin.y -= 30
                self.nextButton.frame.origin.y -= 30
                self.charactersLimitLabel.frame.origin.y -= 30
                self.titleLabel.alpha = 0
                self.nameTextView.alpha = 0
                self.remindsLabel.alpha = 0
                self.nextButton.alpha = 0
                self.charactersLimitLabel.alpha = 0
            },
            completion: { _ in
                
                self.showRemindsContentAnimation()
            }
        )
    }
    
    func showRemindsContentAnimation() {
        
        titleLabel.text = "\(displayNameToUpdate) 今天過得還好嗎？\n反思是 Vini 很重視的每日儀式。"
//        remindsLabel.font = UIFont(name: "PingFangTC-Regular", size: 16)
//        remindsLabel.textColor = .white
        remindsLabel.text = "每到晚上的指定時間，Vini 會帶你進行一次簡單的反思練習，你也可以在這段時間看見其他使用者寫給你的私信。"
        
        let yTransform = CGAffineTransform(translationX: 0, y: -60)
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0.2,
            options: .curveEaseInOut,
            animations: {
                self.titleLabel.frame.origin.y += 30
                self.remindsLabel.transform = yTransform
                self.titleLabel.alpha = 1
                self.remindsLabel.alpha = 1
            },
            completion: { _ in
                
                self.showNotificationButton()
            }
        )
        
    }
    
    func showNotificationButton() {
        
        UIView.animate(
            withDuration: 1.0,
            delay: 0.1,
            options: .curveEaseInOut,
            animations: {
                self.notificationButton.alpha = 1
            },
            completion: nil
        )
    }
    
    func hideNotificationButton() {
        
        UIView.animate(
            withDuration: 1.0,
            delay: 0.1,
            options: .curveEaseInOut,
            animations: {
                self.notificationButton.alpha = 0
            },
            completion: nil
        )
    }
    
    func setupStartMessage() {
        
        titleLabel.text = "\(displayNameToUpdate)，\n謝謝你把時間留給成長。"
        titleLabel.alpha = 0
        remindsLabel.alpha = 0
    }
    
    func showStartButton() {
        
        hideNotificationButton()
        setupStartMessage()
        
        UIView.animate(
            withDuration: 2.0,
            delay: 0.1,
            options: .curveEaseInOut,
            animations: {
                self.titleLabel.alpha = 1
                self.startButton.alpha = 1
            },
            completion: nil
        )
    }
    
    func askForNotificationAuthorization() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("User gave permissions for local notifications")
            }
            
            DispatchQueue.main.async {
                
                let storyboard = UIStoryboard.timePicker
                if let vc = storyboard.instantiateViewController(withIdentifier: StoryboardCategory.timePicker.rawValue) as? TimePickerViewController {
                    
                    vc.delegate = self
                    vc.modalPresentationStyle = .automatic
                    vc.modalTransitionStyle = .crossDissolve
                    
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
    }
    
    func redirectToHomePage() {
        
        let storyboard = UIStoryboard.main
        if let homeVC = storyboard.instantiateViewController(withIdentifier: StoryboardCategory.main.rawValue) as? UITabBarController {
            
            homeVC.selectedIndex = TabBarItem.mailbox.rawValue
            homeVC.modalPresentationStyle = .custom
            homeVC.modalTransitionStyle = .crossDissolve
            
            self.present(homeVC, animated: true, completion: nil)
        }
    }
}
