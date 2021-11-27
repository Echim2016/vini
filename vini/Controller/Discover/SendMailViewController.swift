//
//  SendMailViewController.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/29.
//

import UIKit

class SendMailViewController: UIViewController {
    
    private enum Segue: String {
        
        case showEmptyInputAlert = "ShowEmptyInputAlert"
        case showSendMailAlert = "ShowSendMailAlert"
        case showBlockUserAlert = "ShowBlockUserAlert"
    }
    
    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var receipientNameLabel: UILabel!
    @IBOutlet weak var replyTitleLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var sendMailButton: UIButton!
    
    weak var delegate: DiscoverProtocol?
    
    var contentTextView: UITextView?
    
    var recipient: ViniView?
    var mailToSend = Mail()
    var user: User?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            tableView.showsVerticalScrollIndicator = false
            tableView.isScrollEnabled = true
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
        
        if #available(iOS 14, *) {
            setupButton()
        }
    }
    
    @IBAction func tapDismissButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapBlockUserButton(_ sender: Any) {
        
        performSegue(withIdentifier: Segue.showBlockUserAlert.rawValue, sender: nil)
    }
    
    @IBAction func tapSendButton(_ sender: Any) {
        
        if mailToSend.content.isEmpty {
            
            performSegue(withIdentifier: Segue.showEmptyInputAlert.rawValue, sender: nil)
        } else {
            
            performSegue(withIdentifier: Segue.showSendMailAlert.rawValue, sender: nil)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let alert = segue.destination as? AlertViewController {
            
            switch segue.identifier {
                
            case Segue.showEmptyInputAlert.rawValue:
                
                alert.alertType = .emptyInputAlert
                
            case Segue.showSendMailAlert.rawValue:
                
                alert.alertType = .sendMailAlert
                alert.onConfirm = {
                    
                    self.sendMail()
                }
                
            case Segue.showBlockUserAlert.rawValue:
                
                alert.alertStyle = .danger
                alert.alertType = .blockUserAlert
                alert.onConfirm = {
                    
                    self.blockUser()
                }
                
            default:
                break
            }
        }
    }
}

extension SendMailViewController {
    
    func sendMail() {
        
        if let receipient = recipient,
           let senderID = UserManager.shared.userID {
            
            VProgressHUD.show()
            
            mailToSend.displayWondering = receipient.data.wondering
            mailToSend.senderViniType = receipient.data.viniType
            mailToSend.recipientID = receipient.data.id
            mailToSend.senderID = senderID
            mailToSend.senderDisplayName = user?.displayName ?? "Vini"
            
            MailManager.shared.sendMails(mail: &mailToSend) { result in
                
                switch result {
                case .success(let message):
                    print(message)
                    VProgressHUD.showSuccess()
                    self.dismiss(animated: true, completion: nil)
                    
                case .failure(let error):
                    print(error)
                    VProgressHUD.showFailure(text: "信件寄送出了一些問題，請重新再試")
                }
            }
        } else {
            
            VProgressHUD.showFailure(text: "信件讀取出了一些問題")
        }
    }
    
    func blockUser() {
        
        VProgressHUD.show()
        
        if let blockUserID = recipient?.data.id {
            
            UserManager.shared.updateBlockUserList(blockUserID: blockUserID, action: .block) { result in
                
                switch result {
                case .success:
                    
                    VProgressHUD.dismiss()
                    self.delegate?.willDisplayDiscoverPage()
                    self.dismiss(animated: true, completion: nil)
                    
                case .failure(let error):
                    
                    print(error)
                    VProgressHUD.showFailure(text: "封鎖時出了一些問題，請重新再試")
                }
            }
            
        } else {
            
            VProgressHUD.showFailure(text: "封鎖時出了一些問題")
        }
        
    }
    
}

extension SendMailViewController: UITableViewDelegate {
    
}

extension SendMailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        400
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SetProfileCell.identifier,
            for: indexPath
        ) as? SetProfileCell else {
            fatalError()
        }
        
        cell.setupCell(title: "回覆內容", placeholder: "關於這個狀態，我想分享...")
        cell.textView.delegate = self
        contentTextView = cell.textView
        cell.setTextViewHeight(height: self.view.frame.height - 300)
        
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
        
        switch textView {

        case contentTextView:
            mailToSend.content = text
            
        default:
            break
        }
    }
    
}

extension SendMailViewController {
    
    func setupHeaderInfo() {
        
        if let receipient = recipient {
            senderNameLabel.text = "來自：" + (user?.displayName ?? "Me")
            receipientNameLabel.text = "寄給：" +  receipient.data.name
            replyTitleLabel.text = "回覆：" + receipient.data.wondering
        }
    }
    
    func setupButton() {
        
        sendMailButton.setBackgroundImage(UIImage(systemName: "paperplane.circle.fill"), for: .normal)
    }
}
