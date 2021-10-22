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
        case editContentCard = "EditGrowthContentCard"
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
    
    @IBOutlet weak var footerView: UIView!
    
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
        
        footerView.setTopCurve()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationVC = segue.destination as? SetGrowthContentCardViewController {
            
            destinationVC.growthCaptureVC = self
            destinationVC.contentIntroText = headerTitle
            
            if let growthCardID = sender as? String {
                
                destinationVC.growthCardID = growthCardID
            }
            
            if let index = sender as? Int {
                
                destinationVC.titleToAdd = data[index].title
                destinationVC.contentToAdd = data[index].content
                destinationVC.imageURL = data[index].image
                destinationVC.contentCardID = data[index].id
            }
            
            switch segue.identifier {
                
            case Segue.createContentCard.rawValue:
                destinationVC.currentStatus = .create
                
            case Segue.editContentCard.rawValue:
                destinationVC.currentStatus = .edit
                
            default:
                break
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
        
                UIView.transition(
                    with: self.tableView,
                    duration: 0.5,
                    options: .transitionCrossDissolve,
                    animations: {
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    },
                    completion: nil)
                
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
    private func deleteGrowthContentCard(id: String, imageExists: Bool, completion: @escaping (Bool) -> Void) {
        
        GrowthContentProvider.shared.deleteGrowthContentCard(id: id, imageExists: imageExists) { result in
            
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
        
        // Disable welcome cell's content menu
        if indexPath.row == 0 {
            
            return nil
            
        } else {
            
            let edit = UIAction(
                title: "編輯",
                image: UIImage(systemName: "square.and.pencil")
            ) { _ in
                
                // Navigate to edit page
                self.performSegue(withIdentifier: Segue.editContentCard.rawValue, sender: indexPath.row - 1)
            }
            
            let delete = UIAction(
                title: "刪除",
                image: UIImage(systemName: "trash.fill"),
                attributes: [.destructive]) { _ in
                    
                    let id = self.data[indexPath.row - 1].id
                    let imageExists = !self.data[indexPath.row - 1].image.isEmpty
                    
                    self.deleteGrowthContentCard(id: id, imageExists: imageExists) { success in
                        
                        if success {
                            self.data.remove(at: indexPath.row - 1)
                            self.tableView.deleteRows(at: [indexPath], with: .fade)
                        }
                    }
                }
            
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
                UIMenu(title: "", children: [edit, delete])
            }
        }
    }
    
}
