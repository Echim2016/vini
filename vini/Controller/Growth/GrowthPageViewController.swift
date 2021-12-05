//
//  GrowthPageViewController.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/18.
//

import UIKit

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
    
    @IBOutlet weak var remindsLabel: UILabel! {
        
        didSet {
            
            remindsLabel.text = Tips.randomText()
        }
    }
    
    let growthCardManager = GrowthCardManager.shared
    
    let mailManager = MailManager.shared
    
    var growthCards: [GrowthCard] = [] {
        
        didSet {
            
            remindsLabel.text = Tips.randomText()
            remindsLabel.isHidden = !growthCards.isEmpty
        }
    }
    
    var isReflectionTime: Bool = false {
        
        didSet {
            
            if !isReflectionTime,
               let tabbarController = self.tabBarController as? CustomTabBarController {
                
                tabbarController.stopSound()
            }
        }
    }
    
    var reflectionHour = 23 {
        
        didSet {
            
            let currentHour = Calendar.current.component(.hour, from: Date())
            isReflectionTime = reflectionHour == currentHour
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationController()
        tableView.registerCellWithNib(identifier: GrowthCardCell.identifier, bundle: nil)
        tableView.register(MyGrowthCardsHeader.self, forHeaderFooterViewReuseIdentifier: MyGrowthCardsHeader.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchGrowthCards()
        getReflectionTime()
    }
    
    @IBAction func tapCreateNewGrowthCardButton(_ sender: Any) {
        
        playLightImpactVibration()
        performSegue(withIdentifier: Segue.createNewGrowthCard.rawValue, sender: nil)
    }
    
    @IBAction func tapReflectionButton(_ sender: Any) {
    
        if isReflectionTime {
            
            performSegue(withIdentifier: Segue.showReflectionPage.rawValue, sender: nil)

        } else {
            
            performSegue(withIdentifier: Segue.showReflectionAlert.rawValue, sender: nil)
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
                    
                    alertController.onConfirm = { [weak self] in
                        
                        VProgressHUD.show()
                        
                        guard let self = self else { return }
                        
                        let id = self.growthCards[indexPath.row].id
                        
                        self.deleteGrowthCard(id: id) { success in
                            if success {
                                
                                VProgressHUD.showSuccess()
                                self.growthCards.remove(at: indexPath.row)
                                self.tableView.deleteRows(at: [indexPath], with: .left)
                            } else {
                                
                                VProgressHUD.showFailure()
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
            
            growthCaptureVC.delegate = self
            
            switch segue.identifier {
                
            case Segue.showGrowthCapture.rawValue:
                
                if let index = sender as? Int {
                    
                    growthCaptureVC.growthCard = growthCards[index]
                }
                
            case Segue.createNewGrowthCard.rawValue:
                
                growthCaptureVC.state = .create
                
            default:
                break
            }
        }
    }
    
}

// MARK: - View-related Setup -
extension GrowthPageViewController {
    
    func setupNavigationController() {
        
        let imageView = UIImageView(image: UIImage(named: "vini_logo"))
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
    }
    
}

extension GrowthPageViewController: DataManagerProtocol {
    
    func fetchData() {
        
        fetchGrowthCards()
    }
    
}

extension GrowthPageViewController {
    
    func fetchGrowthCards() {
        
        VProgressHUD.show()
        
        growthCardManager.fetchData(isArchived: false) { result in
            
            switch result {
                
            case .success(let cards):
                
                VProgressHUD.dismiss()
                self.growthCards = cards
                self.tableView.reloadData()
                
            case .failure(let error):
                
                print(error)
                VProgressHUD.showFailure(text: "讀取成長卡片時出了一點問題")
            }
        }
    }
    
    private func deleteGrowthCard(id: String, completion: @escaping (Bool) -> Void) {
        
        VProgressHUD.show()
        
        growthCardManager.deleteGrowthCardAndRelatedCards(id: id) { result in
            
            switch result {
                
            case .success(let success):
                
                print(success)
                VProgressHUD.dismiss()
                completion(true)
                
            case .failure(let error):
                
                print(error)
                VProgressHUD.showFailure(text: "刪除成長卡片時出了一點問題")
                completion(false)
            }
        }
    }
    
    private func getReflectionTime() {
        
        mailManager.getReflectionTime { result in
            
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
        growthCards.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: GrowthCardCell.identifier,
            for: indexPath) as? GrowthCardCell
        else {
            fatalError()
        }
        
        cell.setupCell(title: growthCards[indexPath.row].title, emoji: growthCards[indexPath.row].emoji)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: MyGrowthCardsHeader.identifier) as? MyGrowthCardsHeader
        else {
            return MyGrowthCardsHeader()
        }
        
        header.titleLabel.text = growthCards.isEmpty ?  "" : "我的成長項目"
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        60
    }
    
}

extension GrowthPageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.alpha = 0.2

        UIView.animate(
            withDuration: 0.3,
            delay: 0.05 * Double(indexPath.row),
            animations: {
                cell.alpha = 1
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: Segue.showGrowthCapture.rawValue, sender: indexPath.row)
        playLightImpactVibration(delay: 0.1)
    }
    
    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {
        
        let delete = UIAction.setupAction(of: .delete) { _ in
            
            self.performSegue(withIdentifier: Segue.showDeletionAlert.rawValue, sender: indexPath)
        }
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            UIMenu(title: "", children: [delete])
        }
    }
    
}
