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
    }

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
        }
    }
    
    var mails: [Mail] = []
    
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerCellWithNib(identifier: MailCell.identifier, bundle: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchMails()
        setupNavigationController(title: "收信匣")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? MailDetailViewController {
            
            if let index = sender as? Int {
                
                destination.mail = mails[index]
            }
        }
    }

    @IBAction func tapSetting(_ sender: Any) {
        
        print("settings")
    }
    
}

extension MailboxViewController {
    
    func fetchMails() {

        if let userID = userDefault.value(forKey: "id") as? String {
        
            MailManager.shared.fetchData(id: userID) { result in
                switch result {
                case .success(let mails):
                    
                    self.mails = mails
                    self.tableView.reloadData()
                    
                case .failure(let error):
                    
                    print(error)
                }
            }
        } 
    }
}


extension MailboxViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: Segue.showDetailMail.rawValue, sender: indexPath.row)
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
        }
         
        return cell
    }
    
}

extension MailboxViewController {
    
}
