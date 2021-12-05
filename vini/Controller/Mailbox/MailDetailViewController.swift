//
//  MailDetailViewController.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/30.
//

import UIKit
import RSKPlaceholderTextView

class MailDetailViewController: UIViewController {
    
    private enum Segue: String {
        
        case showBlockAlert = "ShowBlockAlert"
        case showDeleteAlert = "ShowDeleteAlert"
    }
    
    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
        }
    }
    
    @IBOutlet weak var blockUserButton: UIBarButtonItem!
    
    private let userManager = UserManager.shared
    private let mailManager = MailManager.shared
    
    var mail: Mail = Mail() {
        
        didSet {
            
            if mail.senderID == mailManager.welcomeMailSenderID {
                
                blockUserButton.isEnabled = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerCellWithNib(identifier: MailTitleCell.identifier, bundle: nil)
        tableView.registerCellWithNib(identifier: MailCell.identifier, bundle: nil)
        tableView.registerCellWithNib(identifier: MailContentCell.identifier, bundle: nil)
        setupPopGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavBarBackButton()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        updateReadStatus()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func tapDeleteButton(_ sender: Any) {
        
        showDeleteMailAlert()
    }
    
    @IBAction func tapBlockUser(_ sender: Any) {
        
        showBlockUserAlert()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let alert = segue.destination as? AlertViewController {
            
            switch segue.identifier {
                
            case Segue.showBlockAlert.rawValue:
                
                alert.alertStyle = .danger
                alert.alertType = .blockUserAlert
                alert.onConfirm = { [weak self] in
                    
                    guard let self = self else { return }
                    
                    self.blockUser()
                }
                
            case Segue.showDeleteAlert.rawValue:
                
                alert.alertType = .deleteMailAlert
                alert.onConfirm = { [weak self] in
                    
                    guard let self = self else { return }
                    
                    self.deleteMail()
                }
                
            default:
                
                break
                
            }
        }
    }
    
}

extension MailDetailViewController {
    
    private func updateReadStatus() {
        
        if mail.readTimestamp == nil {
            
            mailManager.updateReadTime(
                mailID: mail.id
            ) { result in
                
                switch result {
                case .success(let success):
                    
                    print(success)
                    
                case .failure(let error):
                    
                    print(error)
                }
            }
        }
    }
    
    private func deleteMail() {
        
        VProgressHUD.show()
        
        mailManager.deleteMail(mailID: mail.id) { result in
            
            switch result {
            case .success:
                
                VProgressHUD.showSuccess()
                self.navigationController?.popViewController(animated: true)
                
            case .failure(let error):
                
                print(error)
                VProgressHUD.showFailure(text: "信件刪除時出了一些問題，請重新再試")
            }
        }
    }
    
    private func showDeleteMailAlert() {
        
        performSegue(withIdentifier: Segue.showDeleteAlert.rawValue, sender: nil)
    }
    
    private func showBlockUserAlert() {
        
        performSegue(withIdentifier: Segue.showBlockAlert.rawValue, sender: nil)
    }
    
    private func blockUser() {
        
        VProgressHUD.show()
        
        userManager.updateBlockUserList(blockUserID: mail.senderID, action: .block) { result in
            
            switch result {
            case .success:
                
                VProgressHUD.dismiss()
                self.navigationController?.popViewController(animated: true)
                
            case .failure(let error):
                
                print(error)
                VProgressHUD.showFailure(text: "封鎖使用者時出了一些問題，請重新再試")
            }
        }
    }
    
}

extension MailDetailViewController: UITableViewDelegate {
    
}

extension MailDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        MailDetailRows.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let rowType = MailDetailRows(rawValue: indexPath.row) else { fatalError() }
        
        switch rowType {
                
        case .title:
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: MailTitleCell.identifier,
                for: indexPath) as? MailTitleCell
            else {
                fatalError()
            }
            
            cell.setupCell(title: "回覆：" + mail.displayWondering)
            
            return cell
            
        case .header:
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: MailCell.identifier,
                for: indexPath) as? MailCell
            else {
                fatalError()
            }

            cell.setupCell(
                senderName: mail.senderDisplayName,
                title: mail.sentTime?.toString(format: .mailFormat) ?? "",
                image: mail.senderViniType
            )
            
            cell.setupDetailCellAppearance()
            
            return cell
            
        case .content:
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: MailContentCell.identifier,
                for: indexPath) as? MailContentCell
            else {
                fatalError()
            }
            
            cell.setupCell(content: mail.content)
            
            return cell
        }
    }
    
}
