//
//  SetProfileViewController.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/27.
//

import UIKit

class SetProfileViewController: UIViewController {

    @IBOutlet weak var viniImageView: UIImageView!
    
    var viniAssets = UIImage.AssetIdentifier.allCases
    
    var currentViniIndex: Int = 0 {
        didSet {
            
            if currentViniIndex >= viniAssets.count {
                currentViniIndex = 0
            }
            
            if currentViniIndex < 0 {
                currentViniIndex = viniAssets.count - 1
            }
            
            viniImageView.image = UIImage(assetIdentifier: viniAssets[currentViniIndex])
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
        }
    }
    
    @IBOutlet weak var viniSelectorView: UIView!
    
    @IBOutlet weak var isPublishedSwitch: UISwitch!
    
    let userDefault = UserDefaults.standard
    
    var user: User = User() {
        didSet {
    
            self.isPublishedSwitch.isOn = user.isPublished
            self.viniImageView.image = UIImage(named: user.viniType)
            let types = viniAssets.map { $0.name }
            self.currentViniIndex = types.firstIndex(of: user.viniType) ?? 0
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isModalInPresentation = true
        
        tableView.registerCellWithNib(identifier: SetProfileCell.identifier, bundle: nil)
        
        userDefault.set("rZglCcOTdKRJxD99ZvUg", forKey: "id")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viniImageView.float(duration: 0.5)
        viniSelectorView.setBottomCurve()
        fetchProfile()

    }

    @IBAction func tapDismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapSaveButton(_ sender: Any) {
        
        if !user.wondering.isEmpty,
           !user.displayName.isEmpty {
            saveProfile()
        }
    }
    
    @IBAction func tapLeftArrowButton(_ sender: Any) {
        
        currentViniIndex -= 1
    }
    
    @IBAction func tapRightArrowButton(_ sender: Any) {
        
        currentViniIndex += 1
    }
}

extension SetProfileViewController {
    
    func fetchProfile() {
        
        if let userID = userDefault.value(forKey: "id") as? String {
            
            DiscoverUserManager.shared.fetchUserProfile(id: userID) { result in
                switch result {
                case .success(let user):
                    
                    self.user = user
                    print(user)
                    
                case .failure(let error):
                    
                    print(error)
                }
            }
        }
    
    }
    
    func saveProfile() {
        
        if let userID = userDefault.value(forKey: "id") as? String {
            
            DiscoverUserManager.shared.updateUserStatus(
                id: userID,
                wondering: user.wondering,
                name: user.displayName,
                viniType: viniAssets[currentViniIndex].name,
                isOn: isPublishedSwitch.isOn
            ) { result in
                
                switch result {
                case .success:
                    
                    self.dismiss(animated: true, completion: nil)
                    
                case .failure(let error):
                    
                    print(error)
                }
            }
        }
    }
}

extension SetProfileViewController: UITableViewDelegate {
    
}

extension SetProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        100
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
            cell.setupCell(title: "個人狀態", placeholder: "最近想知道/好奇/煩惱的是...")
            cell.textView.accessibilityLabel = "wondering"
            cell.textView.placeholder = user.wondering as NSString
        case 1:
            cell.setupCell(title: "顯示名稱", placeholder: "呈現在 Vini Town 裡面的名稱")
            cell.textView.accessibilityLabel = "displayName"
            cell.textView.placeholder = user.displayName as NSString
        default:
            break
        }
        
        cell.textView.delegate = self
        
        return cell
        
    }
    
}

extension SetProfileViewController: UITextViewDelegate {
    
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
        case "wondering":
            user.wondering = text
        case "displayName":
            user.displayName = text
        default:
            break
        }
    }
}
