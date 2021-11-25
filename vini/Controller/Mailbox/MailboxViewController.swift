//
//  MailboxViewController.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/28.
//

import UIKit

class MailboxViewController: UIViewController {
    
    private enum Segue: String {
        
        case showDetailMail = "ShowDetailMail"
        case showBlockAlert = "ShowBlockAlert"
    }

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
        }
    }
    
    var mails: [Mail] = [] {
        didSet {
            remindsLabel.isHidden = !mails.isEmpty
        }
    }
        
    var preferredReflectionTime: Int = 23
    
    var userBlockList: [String] = []
    
    @IBOutlet weak var remindsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mails = []
        tableView.registerCellWithNib(identifier: MailCell.identifier, bundle: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchMailsWithoutBlockList()
        getReflectionTime()
        updateBadgeValue()
        setupNavigationController(title: "信箱", titleColor: .white)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? MailDetailViewController {
            
            if let index = sender as? Int {
                
                destination.mail = mails[index]
            }
        }
        
        if let alert = segue.destination as? AlertViewController {
            
            alert.alertStyle = .danger
            alert.alertType = .blockUserAlert
            
            if let indexPath = sender as? IndexPath {
                alert.onConfirm = {
                    self.blockUser(blockUserID: self.mails[indexPath.row].senderID)
                }
            }
        }
    }
    
}

extension MailboxViewController {
    
    func fetchMailsWithoutBlockList() {
        
        VProgressHUD.show()
        
        DiscoverUserManager.shared.fetchUserProfile { result in
            
            switch result {
                
            case .success(let user):
                
                self.userBlockList = user.blockList
                self.fetchMails(blockList: self.userBlockList)
                
            case.failure(let error):
                
                print(error)
                VProgressHUD.showFailure(text: "信件讀取出了一些問題")
                
            }
        }
    }
    
    func fetchMails(blockList: [String]) {
        
        MailManager.shared.fetchData(blockList: blockList) { result in
            switch result {
            case .success(let mails):
                
                VProgressHUD.dismiss()
                self.mails = mails
                self.tableView.reloadData()
                
            case .failure(let error):
                
                self.mails = []
                print(error)
                VProgressHUD.showFailure(text: "信件讀取出了一些問題")
            }
        }
    }
    
    func updateBadgeValue() {
        
        if let tabBar = self.tabBarController as? CustomTabBarController {
            
            tabBar.fetchMailsForBadgeValue()
        }
    }
    
    func getReflectionTime() {
        
        MailManager.shared.getReflectionTime { result in
            switch result {
            case .success(let startTime):
                
                self.preferredReflectionTime = startTime
                
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
    func blockUser(blockUserID: String) {
        
        VProgressHUD.show()
        
        UserManager.shared.blockUser(blockUserID: blockUserID) { result in
            
            switch result {
            case .success:
                
                VProgressHUD.dismiss()
                self.fetchMailsWithoutBlockList()
                
            case .failure(let error):
                
                print(error)
                VProgressHUD.showFailure(text: "封鎖使用者時出了一些問題，請重新再試")
            }
        }
    }

}

extension MailboxViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if mails[indexPath.row].readTimestamp == nil,
           mails[indexPath.row].senderID != MailManager.shared.welcomeMailSenderID {
            
            let currentHour = Calendar.current.component(.hour, from: Date())
            if currentHour == preferredReflectionTime {
                
                performSegue(withIdentifier: Segue.showDetailMail.rawValue, sender: indexPath.row)
            }

        } else {
            
            performSegue(withIdentifier: Segue.showDetailMail.rawValue, sender: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {
        
        let block = UIAction(
            title: "封鎖",
            image: UIImage(systemName: "exclamationmark.bubble.fill"),
            attributes: [.destructive]) { _ in
                
                self.performSegue(withIdentifier: Segue.showBlockAlert.rawValue, sender: indexPath)
            }
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            UIMenu(title: "", children: [block])
        }
    }
    
}

extension MailboxViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mails.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MailCell.identifier,
            for: indexPath) as? MailCell
        else {
            fatalError()
        }
        
        let mail = mails[indexPath.row]
        
        cell.setupCell(
            senderName: mail.senderDisplayName,
            title: "回覆：" + mail.displayWondering,
            image: mail.senderViniType
        )
        
        if mail.readTimestamp != nil {
            
            cell.setupReadAppearance()
            
        } else if mail.senderID != MailManager.shared.welcomeMailSenderID {
            
            let currentHour = Calendar.current.component(.hour, from: Date())
            if currentHour != preferredReflectionTime {
                
                // user can only read unread mail during reflection time
                cell.setupMask()
            }
        }
        
        return cell
    }
    
}
