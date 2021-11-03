//
//  SettingsViewController.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/30.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private enum Segue: String {
        
        case showReflectionTimeSetting = "ShowReflectionTimeSetting"
    }

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var sections: [SettingsSection] = [.notificationSettings]
    
    var rowTitles: [[String]] = [["每日反思時間"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerCellWithNib(identifier: SettingsItemCell.identifier, bundle: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationController(title: "設定")
    }
    
    @IBAction func tapDismissButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: Segue.showReflectionTimeSetting.rawValue, sender: nil)
    }
    
}

extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = UIView()
        
        header.backgroundColor = .clear
        
        let title = UILabel()
        title.text = sections[section].title
        title.textColor = .lightGray
        title.font = UIFont(name: "PingFangTC-Regular", size: 14)
        
        header.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            title.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            title.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 16)
        ])
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsItemCell.identifier, for: indexPath) as? SettingsItemCell else {
            fatalError()
        }
        
        cell.setupCell(title: rowTitles[indexPath.section][indexPath.row])
        
        return cell
    }
    
}