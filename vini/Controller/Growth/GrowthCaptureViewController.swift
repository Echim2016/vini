//
//  GrowthCaptureViewController.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/19.
//

import UIKit
import grpc
import FirebaseFirestore

class GrowthCaptureViewController: UIViewController {
    
    private enum Segue: String {
        
        case createContentCard = "CreateGrowthContentCard"
    }

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerEmojiLabel: UILabel! {
        didSet {
            headerEmojiLabel.text = headerEmoji
        }
    }
    @IBOutlet weak var headerTitleLabel: UILabel! {
        didSet {
            headerTitleLabel.text = headerTitle
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    lazy var headerEmoji: String = ""
    lazy var headerTitle: String = ""
    var growthCardID: String = ""
    
    var data: [GrowthContent] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerCellWithNib(identifier: GrowthContentCell.identifier, bundle: nil)
        
        tableView.registerCellWithNib(identifier: CreateGrowthContentCell.identifier, bundle: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        headerView.setBottomCurve()
        
        self.tabBarController?.tabBar.isHidden = true
        
        fetchGrowthContents()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationVC = segue.destination as? CreateGrowthContentCardViewController {
            
            destinationVC.contentIntroText = headerTitle
            
            if let growthCardID = sender as? String {
                
                destinationVC.growthCardID = growthCardID
            }
        }
    }
    
    @IBAction func tapBackButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func tapCreateGrowthContentCardButton(_ sender: UIButton) {
        
        performSegue(withIdentifier: Segue.createContentCard.rawValue, sender: growthCardID)
    }
}

// MARK: - Firebase -
extension GrowthCaptureViewController {
    
    func fetchGrowthContents() {
        
        GrowthContentProvider.shared.fetchGrowthContents(id: growthCardID) { result in
            
            switch result {
            case .success(let contents):
                
                self.data = contents
                self.tableView.reloadData()
                
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
    func deleteGrowthContentCard(id: String, completion: @escaping (Bool) -> Void) {
        
        GrowthContentProvider.shared.deleteGrowthContentCard(id: id) { result in
            
            switch result {
            case .success(let message):
                print(message)
                completion(true)
                
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
    
    func setupListener() {
        
        Firestore.firestore().collection("Growth_Contents")
            .addSnapshotListener(includeMetadataChanges: true) { _, error in
                
                if let error = error {
                    print(error)
                } else {
                    self.fetchGrowthContents()
                    print("Database has updated")
                }
            }
    }
}

extension GrowthCaptureViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        300
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CreateGrowthContentCell.identifier, for: indexPath) as? CreateGrowthContentCell else {
                fatalError()
            }
            
            cell.createGrowthContentCardButton.addTarget(self, action: #selector(tapCreateGrowthContentCardButton(_:)), for: .touchUpInside)
            
            return cell
            
        } else {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GrowthContentCell.identifier, for: indexPath) as? GrowthContentCell else {
                fatalError()
            }
            
            cell.setupCell(content: data[indexPath.row - 1])
            
            return cell
        }
        
    }
}

extension GrowthCaptureViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

        let delete = UIAction(
            title: "刪除",
            image: UIImage(systemName: "trash.fill"),
            attributes: [.destructive]) { action in
                
                print("delete")
                self.deleteGrowthContentCard(id: self.data[indexPath.row - 1].id) { success in
                    
                    if success {
                        self.data.remove(at: indexPath.row - 1)
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
            }

        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            UIMenu(title: "", children: [delete])
        }

    }
    
}
