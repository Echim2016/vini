//
//  GrowthPageViewController.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/18.
//

import UIKit
import Haptica

class GrowthPageViewController: UIViewController {
    
    private enum Segue: String {
        
        case showGrowthCapture = "ShowGrowthCapture"
        case createNewGrowthCard = "CreateNewGrowthCard"
        case showReflectionAlert = "ShowReflectionAlert"
        case showReflectionPage = "ShowReflectionPage"
        case showDeletionAlert = "ShowDeletionAlert"

    }

    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    @IBOutlet weak var remindsLabel: UILabel!
    
    var data: [GrowthCard] = [] {
        
        didSet {
            
            remindsLabel.isHidden = !data.isEmpty
        }
    }
    
    var reflectionHour = 23
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationController()
        
        tableView.registerCellWithNib(identifier: GrowthCardCell.identifier, bundle: nil)
        
        tableView.register(MyGrowthCardsHeader.self, forHeaderFooterViewReuseIdentifier: MyGrowthCardsHeader.identifier)
        
        getReflectionTime()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchGrowthCards()
    }
    
    @IBAction func tapCreateNewGrowthCardButton(_ sender: Any) {
        
        Haptic.play(".", delay: 0)
        performSegue(withIdentifier: "CreateNewGrowthCard", sender: nil)
    }
    
    @IBAction func tapReflectionButton(_ sender: Any) {
    
        let currentHour = Calendar.current.component(.hour, from: Date())

        if currentHour != reflectionHour {
            
            performSegue(withIdentifier: Segue.showReflectionAlert.rawValue, sender: nil)
            
        } else {
            
            performSegue(withIdentifier: Segue.showReflectionPage.rawValue, sender: nil)
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let alertController = segue.destination as? AlertViewController {
            
            switch segue.identifier {
                
            case Segue.showReflectionAlert.rawValue:
                alertController.alertType = .reflectionTimeAlert
                
            case Segue.showDeletionAlert.rawValue:
                alertController.alertType = .deleteGrowthCardAlert
                
                if let indexPath = sender as? IndexPath {
                    
                    alertController.onConfirm = {
                        
                        let id = self.data[indexPath.row].id
                        
                        self.deleteGrowthCard(id: id) { success in
                            if success {
                                self.data.remove(at: indexPath.row)
                                self.tableView.deleteRows(at: [indexPath], with: .left)
                            }
                        }
                    }
                }
                
            default:
                break

            }
        }
        
        if let navigationController = segue.destination as? UINavigationController,
           let growthCaptureVC = navigationController.topViewController as? GrowthCaptureViewController {
            
            growthCaptureVC.growthPageVC = self
            
            switch segue.identifier {
                
            case Segue.showGrowthCapture.rawValue:
                
                if let index = sender as? Int {
                    
                    growthCaptureVC.headerEmoji = data[index].emoji
                    growthCaptureVC.headerTitle = data[index].title
                    growthCaptureVC.growthCardID = data[index].id
                }
                
            case Segue.createNewGrowthCard.rawValue:
                
                growthCaptureVC.isInCreateCardMode = true
                
            default:
                break
            }
        }
    }
}

// MARK: - View-releated Setup -
extension GrowthPageViewController {
    
    func setupNavigationController() {
        
        let imageView = UIImageView(image: UIImage(named: "vini_logo"))
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
    }
    
}

extension GrowthPageViewController {
    
    func fetchGrowthCards() {
        
        GrowthCardProvider.shared.fetchData(isArchived: false) { result in
            
            switch result {
            case .success(let cards):
                
                self.data = cards
                self.tableView.reloadData()
                
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
    private func deleteGrowthCard(id: String, completion: @escaping (Bool) -> Void) {
        
        GrowthCardProvider.shared.deleteGrowthCardAndRelatedCards(id: id) { result in
            
            switch result {
            case .success(_):
                
                completion(true)
                
            case .failure(let error):
                
                print(error)
                completion(false)
            }
        }
        
    }
    
    private func getReflectionTime() {
        
        MailManager.shared.getReflectionTime { result in
            switch result {
            case .success(let hour):
                
                self.reflectionHour = hour
                
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
}

extension GrowthPageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GrowthCardCell.identifier, for: indexPath) as? GrowthCardCell else {
            fatalError()
        }
        
        cell.setupCell(title: data[indexPath.row].title, emoji: data[indexPath.row].emoji)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: MyGrowthCardsHeader.identifier) as? MyGrowthCardsHeader else {
            return MyGrowthCardsHeader()
        }
        
        header.titleLabel.text = data.isEmpty ?  "" : "我的成長項目"
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        60
    }
}

extension GrowthPageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "ShowGrowthCapture", sender: indexPath.row)
        Haptic.play(".", delay: 0.1)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let delete = UIAction(
            title: "刪除",
            image: UIImage(systemName: "trash.fill"),
            attributes: [.destructive]) { _ in
                
                self.performSegue(withIdentifier: Segue.showDeletionAlert.rawValue, sender: indexPath)
            }
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            UIMenu(title: "", children: [delete])
        }
    }
    
}
