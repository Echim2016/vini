//
//  SettingsViewController.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/30.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {
    
    private enum Segue: String {
        
        case showReflectionTimeSetting = "ShowReflectionTimeSetting"
        case showLogOutAlert = "ShowLogOutAlert"
        case showBlockList = "ShowBlockList"
        case showPrivacyPage = "ShowPrivacyPage"
    }

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var sections: [SettingsSection] = SettingsSection.allCases
    
    var rowTitles: [[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerCellWithNib(identifier: SettingsItemCell.identifier, bundle: nil)
        
        rowTitles = sections.map { $0.settingItems }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationController(title: "設定", titleColor: .white)
    }
    
    @IBAction func tapDismissButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
            
        case Segue.showLogOutAlert.rawValue:
            
            if let alert = segue.destination as? AlertViewController {
                
                alert.alertType = .logOutAlert
                
                alert.onConfirm = {
                    
                    let firebaseAuth = Auth.auth()
            
                    do {
                        try firebaseAuth.signOut()
                                                
                    } catch let signOutError as NSError {
                        print("Error signing out: %@", signOutError)
                        VProgressHUD.showFailure()
                    }
                    
                    if let signinNav = UIStoryboard.signIn.instantiateViewController(withIdentifier: StoryboardCategory.signIn.rawValue) as? UINavigationController {
                        
                        if let sceneDelegate: SceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                            sceneDelegate.window?.rootViewController = signinNav
                            sceneDelegate.window?.makeKeyAndVisible()
                        }
                    }
                }
            }
            
        default:
            break
        }
        
    }
    
}

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch (indexPath.section, indexPath.row) {
            
        case (0, 0):
            
            performSegue(withIdentifier: Segue.showReflectionTimeSetting.rawValue, sender: nil)
            
        case (1, 0):
            
            performSegue(withIdentifier: Segue.showBlockList.rawValue, sender: nil)
            
        case (1, 1):
            
            performSegue(withIdentifier: Segue.showLogOutAlert.rawValue, sender: nil)
            
        case (SettingsSection.about.rawValue, 0):
            
            performSegue(withIdentifier: Segue.showPrivacyPage.rawValue, sender: nil)
            
        default:
            break
            
        }
    }
    
}

extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rowTitles[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = TitleHeaderView()
        
        header.setupHeaderView(
            backgroundColor: .clear,
            textColor: .lightGray,
            fontSize: 14,
            text: sections[section].title
        )
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        36
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingsItemCell.identifier,
            for: indexPath) as? SettingsItemCell
        else {
            fatalError()
        }
        
        cell.setupCell(title: rowTitles[indexPath.section][indexPath.row])
        
        return cell
    }
    
}
