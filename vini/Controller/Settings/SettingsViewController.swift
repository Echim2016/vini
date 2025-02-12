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
        case showBlockList = "ShowBlockList"
        case showLogOutAlert = "ShowLogOutAlert"
        case showDeleteAccountAlert = "ShowDeleteAccountAlert"
        case showPrivacyPage = "ShowPrivacyPage"
    }

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
  
    @IBOutlet weak var versionNumberLabel: UILabel!
  
    var sections: [SettingsSection] = SettingsSection.allCases
    
    var rowTitles: [[SettingsTitle]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerCellWithNib(identifier: SettingsItemCell.identifier, bundle: nil)
        
        rowTitles = sections.map { $0.settingItems }
      
      if let versionNumber = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String {
        versionNumberLabel.text = "v\(versionNumber)"
      }
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
        
        guard let section = SettingsSection(rawValue: indexPath.section) else {
            
                  fatalError()
              }
        
        let rowTitle = section.settingItems[indexPath.row]
        
        switch (section, rowTitle) {
            
        case (.notification, .reflectionTime):
            
            performSegue(withIdentifier: Segue.showReflectionTimeSetting.rawValue, sender: nil)
            
        case (.account, .blockedUsers):
            
            performSegue(withIdentifier: Segue.showBlockList.rawValue, sender: nil)
            
        case (.account, .logOut):
            
            performSegue(withIdentifier: Segue.showLogOutAlert.rawValue, sender: nil)
            
        case (.account, .deleteAccount):
            
            performSegue(withIdentifier: Segue.showDeleteAccountAlert.rawValue, sender: nil)
            
        case (.about, .privacyPolicy):
            
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
        
        cell.setupCell(title: rowTitles[indexPath.section][indexPath.row].title)
        
        return cell
    }
    
}
