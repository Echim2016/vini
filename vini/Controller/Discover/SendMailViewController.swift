//
//  SendMailViewController.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/29.
//

import UIKit

class SendMailViewController: UIViewController {
    
    private enum Segue: String {
        
        case showBlockUserAlert = "ShowBlockUserAlert"
    }
    
    @IBOutlet weak var receipientNameLabel: UILabel!
    @IBOutlet weak var replyTitleLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    
    var receipient: ViniView?
    
    var mailToSend = Mail()
    
    weak var delegate: DiscoverProtocol?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isModalInPresentation = true
        
        tableView.registerCellWithNib(identifier: SetProfileCell.identifier, bundle: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        headerView.setBottomCurve()
        
        setupHeaderInfo()
    }
    
    @IBAction func tapDismissButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapSendButton(_ sender: Any) {
        
        sendMail()
    }
    
    @IBAction func tapBlockButton(_ sender: Any) {
        
        performSegue(withIdentifier: Segue.showBlockUserAlert.rawValue, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let alert = segue.destination as? AlertViewController {
            
            alert.alertType = .blockUserAlert
            alert.onConfirm = {
                
                self.blockUser()
            }
        }
    }
}

extension SendMailViewController {
    
    func sendMail() {
        
        if let receipient = receipient,
           let senderID = UserManager.shared.userID {
            
            mailToSend.displayWondering = receipient.data.wondering
            mailToSend.senderViniType = receipient.data.viniType
            mailToSend.receipientID = receipient.data.id
            mailToSend.senderID = senderID
            
            MailManager.shared.sendMails(mail: &mailToSend) { result in
                
                switch result {
                case .success(let message):
                    print(message)
                    self.dismiss(animated: true, completion: nil)
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func blockUser() {
        
        if let receipientID = receipient?.data.id {
            
            UserManager.shared.blockUser(blockUserID: receipientID) { result in
                
                switch result {
                case .success:
                    
                    self.delegate?.willDisplayDiscoverPage()
                    self.dismiss(animated: true, completion: nil)
                    
                case .failure(let error):
                    
                    print(error)
                }
            }
        }
        
    }
    
}

extension SendMailViewController: UITableViewDelegate {
    
}

extension SendMailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SetProfileCell.identifier,
            for: indexPath
        ) as? SetProfileCell else {
            fatalError()
        }
        
        switch indexPath.row {
            
        case 0:
            cell.setupCell(title: "顯示名稱", placeholder: "我想要顯示在對方收信匣的名稱是...")
            cell.textView.accessibilityLabel = "displayName"
            
        case 1:
            cell.setupCell(title: "回覆內容", placeholder: "關於這個狀態，我想分享...")
            cell.textView.accessibilityLabel = "content"
            cell.setTextViewHeight(height: self.view.frame.height)
        default:
            break
        }
        
        cell.textView.delegate = self
        
        return cell
    }
    
}

extension SendMailViewController: UITextViewDelegate {
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        
        textView.resignFirstResponder()
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        guard let text = textView.text,
              !text.isEmpty else {
                  return
              }
        
        switch textView.accessibilityLabel {
        case "displayName":
            mailToSend.senderDisplayName = text
        case "content":
            mailToSend.content = text
        default:
            break
        }
    }
    
}

extension SendMailViewController {
    
    func setupHeaderInfo() {
        
        if let receipient = receipient {
            receipientNameLabel.text = "寄給：" +  receipient.data.name
            replyTitleLabel.text = "回覆：" + receipient.data.wondering
        }
    }
}
