//
//  SetProfileViewController.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/27.
//

import UIKit

class SetProfileViewController: UIViewController {
    
    private enum Segue: String {
        
        case showEmptyInputAlert = "ShowEmptyInputAlert"
    }

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
            tableView.showsVerticalScrollIndicator = false
        }
    }
    
    @IBOutlet weak var viniSelectorView: UIView!
    
    @IBOutlet weak var isPublishedSwitch: UISwitch!
    
    weak var delegate: DiscoverProtocol?
        
    var user: User = User() {
        didSet {
    
            self.isPublishedSwitch.isOn = user.isPublished
            self.selectedIndex = cloudCategorySelection.firstIndex(where: { item in
                item.category.category == user.cloudCategory
            }) ?? 0
            cloudCategorySelection[selectedIndex].isChecked = true
            self.tableView.reloadData()
        }
    }
    
    var cloudCategorySelection: [CloudCategorySelection] = [
        CloudCategorySelection(category: CloudCategory.career),
        CloudCategorySelection(category: CloudCategory.relationship),
        CloudCategorySelection(category: CloudCategory.selfGrowth),
        CloudCategorySelection(category: CloudCategory.lifestyle)
    ]
    
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isModalInPresentation = true
        
        tableView.registerCellWithNib(identifier: SetProfileCell.identifier, bundle: nil)
        tableView.registerCellWithNib(identifier: SetCloudCategoryTitleCell.identifier, bundle: nil)
        tableView.registerCellWithNib(identifier: SetCloudCategoryCell.identifier, bundle: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viniImageView.float(duration: 0.9)
        viniSelectorView.setBottomCurve()
        fetchProfile()
    }

    @IBAction func tapSwitch(_ sender: Any) {
    
        if sender is UISwitch {
            
            tableView.reloadData()
        }
    }
    
    @IBAction func tapDismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapSaveButton(_ sender: Any) {
        
        view.endEditing(true)

        if (!user.wondering.isEmpty && !user.displayName.isEmpty) || !isPublishedSwitch.isOn {
            
            saveProfile()
            
        } else {
            
            performSegue(withIdentifier: Segue.showEmptyInputAlert.rawValue, sender: nil)
        }
    }
    
    @IBAction func tapLeftArrowButton(_ sender: Any) {
        
        currentViniIndex -= 1
    }
    
    @IBAction func tapRightArrowButton(_ sender: Any) {
        
        currentViniIndex += 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let alert = segue.destination as? AlertViewController {
            
            alert.alertType = .emptyInputAlert
        }
    }
}

extension SetProfileViewController {
    
    func fetchProfile() {
                    
        DiscoverUserManager.shared.fetchUserProfile() { result in
            switch result {
            case .success(let user):
                
                self.user = user
                let types = self.viniAssets.map { $0.name }
                self.currentViniIndex = types.firstIndex(of: user.viniType) ?? 0
                self.viniImageView.image = UIImage(named: user.viniType)
                
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
    func saveProfile() {
        
        DiscoverUserManager.shared.updateUserStatus(
            wondering: user.wondering,
            name: user.displayName,
            viniType: viniAssets[currentViniIndex].name,
            isOn: isPublishedSwitch.isOn,
            category: cloudCategorySelection[selectedIndex].category.category
        ) { result in
            
            switch result {
            case .success:
                
                self.delegate?.didSelectCloudCategory(self.cloudCategorySelection[self.selectedIndex].category)
                self.dismiss(animated: true, completion: nil)
                
            case .failure(let error):
                
                print(error)
            }
        }
    }
}

extension SetProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
            
        case 3..<3 + cloudCategorySelection.count:
            
            let lastIndexPath = IndexPath(row: selectedIndex + 3, section: 0)
            cloudCategorySelection[selectedIndex].isChecked = false
            cloudCategorySelection[indexPath.row - 3].isChecked = true
            selectedIndex = indexPath.row - 3
            tableView.reloadRows(at: [lastIndexPath, indexPath], with: .none)
            
        default:
            break
        }
        
    }
    
}

extension SetProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3 + cloudCategorySelection.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            
        case 0:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SetProfileCell.identifier,
                for: indexPath
            ) as? SetProfileCell else {
                fatalError()
            }
            cell.setupCell(title: "個人狀態", placeholder: "最近想知道/好奇/煩惱的是...")
            cell.textView.delegate = self
            cell.textView.accessibilityLabel = "wondering"
            cell.textView.text = user.wondering
            cell.isHidden = !isPublishedSwitch.isOn
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SetProfileCell.identifier,
                for: indexPath
            ) as? SetProfileCell else {
                fatalError()
            }
            cell.setupCell(title: "顯示名稱", placeholder: "呈現在 Vini Cloud 裡面的名稱")
            cell.textView.delegate = self
            cell.textView.accessibilityLabel = "displayName"
            cell.textView.text = user.displayName
            cell.isHidden = !isPublishedSwitch.isOn

            return cell
            
        case 2:
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SetCloudCategoryTitleCell.identifier,
                for: indexPath
            ) as? SetCloudCategoryTitleCell else {
                fatalError()
            }
            cell.isHidden = !isPublishedSwitch.isOn

            return cell
            
        case 3...6:
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SetCloudCategoryCell.identifier,
                for: indexPath
            ) as? SetCloudCategoryCell else {
                fatalError()
            }
            
            cell.setupCell(
                title: cloudCategorySelection[indexPath.row - 3].category.title,
                isChecked: cloudCategorySelection[indexPath.row - 3].isChecked
            )
            cell.isHidden = !isPublishedSwitch.isOn

            return cell

        default:
            return UITableViewCell()
        }
        
    }
    
}

extension SetProfileViewController: UITextViewDelegate {
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        
        textView.resignFirstResponder()
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText = textView.text ?? ""

        guard let stringRange = Range(range, in: currentText) else { return false }

        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)

        return updatedText.count <= 18
    }
}
