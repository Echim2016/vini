//
//  MailboxViewController.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/28.
//

import UIKit

class MailboxViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var mails: [Mail] = []
    
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerCellWithNib(identifier: MailCell.identifier, bundle: nil)
        
        fetchMails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
            title: mail.displayWondering,
            image: mail.senderViniType
        )
        
        print(mail.displayWondering)
        
        return cell
    }
    
}

extension MailboxViewController {
    
}
