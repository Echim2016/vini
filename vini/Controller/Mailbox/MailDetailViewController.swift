//
//  MailDetailViewController.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/30.
//

import UIKit
import RSKPlaceholderTextView

class MailDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
        }
    }
    
    var mail: Mail = Mail()
    
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerCellWithNib(identifier: MailTitleCell.identifier, bundle: nil)
        tableView.registerCellWithNib(identifier: MailCell.identifier, bundle: nil)
        tableView.registerCellWithNib(identifier: MailContentCell.identifier, bundle: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavBarBackButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        updateReadStatus()
    }
    
    @IBAction func tapDeleteButton(_ sender: Any) {
        
        deleteMail()
    }
    
}

extension MailDetailViewController {
    
    func updateReadStatus() {
        
        if mail.readTimestamp == nil,
           let userID = userDefault.value(forKey: "id") as? String {
            
            MailManager.shared.updateReadTime(
                userID: userID,
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
    
    func deleteMail() {
        
        if let userID = userDefault.value(forKey: "id") as? String {
            
            MailManager.shared.deleteMail(
                userID: userID,
                mailID: mail.id) { result in
                    switch result {
                    case .success:
                        
                        self.navigationController?.popViewController(animated: true)
                        
                    case .failure(let error):
                        
                        print(error)
                    }
                }
        }
        
    }
}

extension MailDetailViewController: UITableViewDelegate {
    
}

extension MailDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
                
        case 0:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MailTitleCell.identifier, for: indexPath) as? MailTitleCell else {
                fatalError()
            }
            
            cell.setupCell(title: "回覆：" + mail.displayWondering)
            
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MailCell.identifier, for: indexPath) as? MailCell else {
                fatalError()
            }

            cell.setupCell(
                senderName: mail.senderDisplayName,
                title: mail.sentTime?.toString() ?? "",
                image: mail.senderViniType
            )
            
            cell.setupDetailCellAppearance()
            
            return cell
            
        case 2:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MailContentCell.identifier, for: indexPath) as? MailContentCell else {
                fatalError()
            }
            
            cell.setupCell(content: mail.content)
            
            return cell

        default:
            
            return UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        }
    }
    
}
