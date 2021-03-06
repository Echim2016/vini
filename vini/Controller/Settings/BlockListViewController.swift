//
//  BlockListViewController.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/11/9.
//

import UIKit

class BlockListViewController: UIViewController {
    
    private enum Segue: String {
        
        case showUnblockUserAlert = "ShowUnblockUserAlert"
    }

    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    @IBOutlet weak var introLabel: UILabel!
    
    private let discoverUserManager = DiscoverUserManager.shared
    private let userManager = UserManager.shared
    
    private var userBlockList: [String] = []
    
    private var blockUsers: [User] = [] {
        
        didSet {
            
            if blockUsers.count == userBlockList.count {
                
                self.tableView.reloadData()
            }
            
            introLabel.isHidden = !blockUsers.isEmpty
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupPopGestureRecognizer()
        tableView.registerCellWithNib(identifier: BlockUserCell.identifier, bundle: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        playLightImpactVibration()
        setupNavigationController(title: "已封鎖的使用者", titleColor: .white)
        setupNavBarBackButton()
        blockUsers = []
        fetchUserProfile()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let alert = segue.destination as? AlertViewController,
           let indexPath = sender as? IndexPath {
            
            let blockUserID = blockUsers[indexPath.row].id
            
            alert.alertType = .unblockUserAlert
            alert.onConfirm = { [weak self] in
                
                guard let self = self else { return }
                
                self.unblockUser(id: blockUserID, indexPath: indexPath)
            }
        }
    }

}

extension BlockListViewController {
    
    private func fetchUserProfile() {
                
        discoverUserManager.fetchUserProfile { result in
            
            switch result {
                
            case .success(let user):
                
                self.userBlockList = user.blockList
                
                if !self.userBlockList.isEmpty {
                    
                    self.fetchBlockUsersList(list: self.userBlockList)
                }
                
            case.failure(let error):
                
                print(error)
            }
        }
    }
    
    private func fetchBlockUsersList(list: [String]) {
                
        userBlockList.forEach { userID in
            
            userManager.fetchUser(userID: userID) { result in
                
                switch result {
                    
                case .success(let user):
                    
                    self.blockUsers.append(user)
                    
                case.failure(let error):
                    
                    print(error)
                }
            }
            
        }
    }
    
    private func unblockUser(id: String, indexPath: IndexPath) {
        
        userManager.updateBlockUserList(blockUserID: id, action: .unblock) { result in
            
            switch result {
                
            case .success(let success):
                
                if success {
                    
                    self.userBlockList.remove(at: indexPath.row)
                    self.blockUsers.remove(at: indexPath.row)
                    self.tableView.reloadData()
                }
                
            case.failure(let error):
                
                print(error)
            }
        }
    }
}

extension BlockListViewController: BlockUserProtocol {
    
    func didTapUnblockButton(_ cell: BlockUserCell) {
        
        if let indexPath = tableView.indexPath(for: cell) {
                        
            performSegue(withIdentifier: Segue.showUnblockUserAlert.rawValue, sender: indexPath)
        }
    }
}

extension BlockListViewController: UITableViewDelegate {
    
}

extension BlockListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        blockUsers.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: BlockUserCell.identifier,
                                                       for: indexPath) as? BlockUserCell else {
            fatalError()
        }
        
        cell.setupCell(user: blockUsers[indexPath.row])
        cell.delegate = self
        
        return cell
    }
    
}
