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
    
    var nextButton = NextButton()
    
    var notificationButton = NextButton()
    
    var startButton = NextButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupBackgroundView()
        setupTextView()
        setupNextButton()
        setupNotifacationButton()
        setupStartButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showContentAnimation()
    }
    
    @objc func tapNextButton(_ sender: UIButton) {
        
        view.endEditing(true)
        hideContentAnimation()
    }
    
    @objc func tapNotificationButton(_ sender: UIButton) {
        
        askForNotificationAuthorization()
    }
    
    @objc func tapStartButton(_ sender: UIButton) {
        
//        askForNotificationAuthorization()
    }
}

extension SignupViewController: UITextViewDelegate {
    
    
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
    
    func setupNotifacationButton() {
        
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
                self.titleLabel.alpha = 0
                self.nameTextView.alpha = 0
                self.remindsLabel.alpha = 0
                self.nextButton.alpha = 0
            },
            completion: { _ in
                
                self.showRemindsContentAnimation()
            }
        )
    }
    
    func showRemindsContentAnimation() {
        
        titleLabel.text = "每日反思時段"
        remindsLabel.font = UIFont(name: "PingFangTC-Regular", size: 16)
//        remindsLabel.textColor = .white
        remindsLabel.text = "Vini會帶你進行一次簡單的反思練習，你也可以在這段時間看見其他使用者寫給你的私信。"
        
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
    
    func showStartButton() {
        
        UIView.animate(
            withDuration: 1.0,
            delay: 0.1,
            options: .curveEaseInOut,
            animations: {
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
                
                let storyboard = UIStoryboard(name: "TimePicker", bundle: nil)
                if let vc = storyboard.instantiateViewController(withIdentifier: "TimePicker") as? TimePickerViewController {
                    
//                    self.navigationController?.pushViewController(vc, animated: false)
                    vc.modalPresentationStyle = .automatic
                    vc.modalTransitionStyle = .crossDissolve
//                    vc.view.backgroundColor = .clear
                    
                    self.present(vc, animated: true, completion: nil)
                }
                
                
            }
        }
    }
}
