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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isModalInPresentation = true
        
        tableView.registerCellWithNib(identifier: SetWonderingCell.identifier, bundle: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viniImageView.float(duration: 0.5)
        viniSelectorView.setBottomCurve()
    }

    @IBAction func tapDismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapSaveButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapLeftArrowButton(_ sender: Any) {
        
        currentViniIndex -= 1
    }
    
    @IBAction func tapRightArrowButton(_ sender: Any) {
        
        currentViniIndex += 1
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SetWonderingCell.identifier, for: indexPath) as? SetWonderingCell else {
            fatalError()
        }
        
        switch indexPath.row {
            
        case 0:
            cell.setupCell(title: "個人狀態", placeholder: "最近想知道/好奇/煩惱的是...")
        case 1:
            cell.setupCell(title: "顯示名稱", placeholder: "呈現在 Vini Town 裡面的名稱")
        default:
            break
            
        }
        
        return cell
        
    }
    
}
