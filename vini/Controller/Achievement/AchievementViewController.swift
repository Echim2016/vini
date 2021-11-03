//
//  AchievementViewController.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/29.
//

import UIKit

class AchievementViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
        }
    }
        
    var collectionViewForGrowthCards: UICollectionView?
    
    var collectionViewForInsights: UICollectionView?
    
    var sectionTitles = AchievementSection.allCases
    
    var insightTitles = InsightTitle.allCases
    
    var insightDict: [InsightTitle : String] = [:]
    
    var growthCards: [GrowthCard] = []
    
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerCellWithNib(identifier: ArchivedCardCell.identifier, bundle: nil)
        
        setupNavigationController(title: "成就")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        fetchGrowthCards()
        fetchInsights()
    }
    
    @objc func tapShowCardDetailButton(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "GrowthCapture", bundle: nil)
        
        if let navigationController = storyboard.instantiateViewController(withIdentifier: "GrowthCaptureNav") as? UINavigationController,
           let controller = navigationController.topViewController as? GrowthCaptureViewController {
            
            controller.headerEmoji = growthCards[sender.tag].emoji
            controller.headerTitle = growthCards[sender.tag].title
            controller.growthCardID = growthCards[sender.tag].id
            controller.isInArchivedMode = true
            
            present(navigationController, animated: true, completion: nil)
        }
    }
    
}

extension AchievementViewController {
    
    func fetchGrowthCards() {
        
        if let userID = userDefault.value(forKey: "id") as? String {
            
            GrowthCardProvider.shared.fetchData(userID: userID, isArchived: true) { result in
                
                switch result {
                case .success(let cards):
                    
                    self.growthCards = cards
                    DispatchQueue.main.async {
                        
                        self.collectionViewForGrowthCards?.reloadData()
                    }
                    
                    
                case .failure(let error):
                    
                    print(error)
                }
            }
        }
    }
    
    func fetchInsights() {
        
        if let userID = userDefault.value(forKey: "id") as? String {
        
            InsightManager.shared.fetchInsights(userID: userID) { result in
                
                switch result {
                case .success(let insightDict):
                    
                    self.insightDict = insightDict
                    DispatchQueue.main.async {
                        
                        self.collectionViewForInsights?.reloadData()
                    }
                    
                case .failure(let error):
                    
                    print(error)
                }
            }
        }
    }
    
}

// MARK: - Table View -
extension AchievementViewController: UITableViewDelegate {
    
}

extension AchievementViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        450
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = UIView()
        
        header.backgroundColor = .B1
        
        let title = UILabel()
        title.text = sectionTitles[section].title
        title.textColor = .white
        title.font = UIFont(name: "PingFangTC-Semibold", size: 18)
        
        header.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            title.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            title.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 16)
        ])
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ArchivedCardCell.identifier, for: indexPath) as? ArchivedCardCell else {
                fatalError()
            }
        
            cell.setupLayoutForGrowthCards()
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            self.collectionViewForGrowthCards = cell.collectionView
            
            return cell
            
        case 1:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ArchivedCardCell.identifier, for: indexPath) as? ArchivedCardCell else {
                fatalError()
            }
            
            cell.setupLayoutForInsight(width: tableView.frame.size.width)
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            self.collectionViewForInsights = cell.collectionView
            
            return cell
            
        default:
            
            return UITableViewCell.init()
        }
    }
}

// MARK: - Collection View -
extension AchievementViewController: UICollectionViewDelegate {
    
}

extension AchievementViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
            
        case collectionViewForGrowthCards:
            return growthCards.count
        case collectionViewForInsights:
            return insightTitles.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
            
        case collectionViewForGrowthCards:
            
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: ArchivedCardCollectionViewCell.self),
                for: indexPath
            )

            guard let cardCell = cell as? ArchivedCardCollectionViewCell
    //              let product = datas[indexPath.section][indexPath.row] as? Product
            else {

                return cell
            }
            
            cardCell.setupCell(growthCard: growthCards[indexPath.row], index: indexPath.row)
            cardCell.rightArrowButton.addTarget(self, action: #selector(tapShowCardDetailButton(_:)), for: .touchUpInside)

            return cardCell
            
        case collectionViewForInsights:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: InsightCollectionViewCell.self),
                for: indexPath
            )

            guard let insightCell = cell as? InsightCollectionViewCell
            else {

                return cell
            }
            
            let title = insightTitles[indexPath.row].title
            let data = insightDict[insightTitles[indexPath.row]] ?? "00"
            insightCell.setupCell(title: title, data: data)
            
            return insightCell
            
        default:
            return UICollectionViewCell.init()
        }
        
    }
    
}
