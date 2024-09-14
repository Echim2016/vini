//
//  AchievementViewController.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/29.
//

import UIKit
    
class AchievementViewController: UIViewController {
    
    private enum Segue: String {
        
        case showSettings = "ShowSettings"
    }

    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
        }
    }
    
    @IBOutlet weak var welcomeCardView: UIView!
    @IBOutlet weak var welcomeActionButton: MainButton!
    @IBOutlet weak var welcomeTitleLabel: UILabel!
    @IBOutlet weak var userViniImageView: UIImageView!
    
    var cardManager = GrowthCardManager.shared
    var insightManager = InsightManager.shared

    var collectionViewForGrowthCards: UICollectionView?
    var collectionViewForInsights: UICollectionView?
    var sectionTitles = AchievementSection.allCases
    var insightTitles = InsightTitle.allCases
    var insightDict: [InsightTitle: String] = [:]
    var growthCards: [GrowthCard] = [] {
        
        didSet {
            
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ArchivedCardCell {
                
                cell.remindsLabel.isHidden = !growthCards.isEmpty
            }
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerCellWithNib(identifier: ArchivedCardCell.identifier, bundle: nil)
        tableView.showsVerticalScrollIndicator = false
        setupNavigationController(title: "我的成就", titleColor: .white)
        setupNotificationCenterObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        fetchGrowthCards()
        fetchInsights()
        setupWelcomeCardView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showWelcomeContentAnimation()
    }
    
    @IBAction func tapSettingsButton(_ sender: Any) {
   
        playLightImpactVibration()
        performSegue(withIdentifier: Segue.showSettings.rawValue, sender: nil)
    }
    
    @IBAction func tapWelcomeActionButton(_ sender: Any) {
        
        playLightImpactVibration()
        self.tabBarController?.selectedIndex = TabBarItem.growth.rawValue
    }
    
    @objc func tapShowCardDetailButton(_ sender: UIButton) {
        
        let storyboard = UIStoryboard.growthCapture
        
        if let navigationController = storyboard.instantiateViewController(withIdentifier: StoryboardCategory.growthCapture.rawValue) as? UINavigationController,
           let controller = navigationController.topViewController as? GrowthCaptureViewController {
            
            controller.growthCard = growthCards[sender.tag]
            controller.state = .review
            
            playLightImpactVibration()
            present(navigationController, animated: true, completion: nil)
        }
    }
    
}

extension AchievementViewController {
    
    func fetchGrowthCards() {
        
        cardManager.fetchData(isArchived: true) { result in
            
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
    
    func fetchInsights() {
        
        insightManager.fetchInsights { result in
            
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
    
    func unarchiveGrowthCard(id: String) {
        
        VProgressHUD.show()
        
        cardManager.unarchiveGrowthCard(id: id) { result in
            
            switch result {
                
            case .success(let success):
                
                print(success)
                self.fetchGrowthCards()
                VProgressHUD.showSuccess()
                
            case .failure(let error):
                
                print(error)
                VProgressHUD.showFailure()
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
        AchievementSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        450
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = TitleHeaderView()
        
        header.setupHeaderView(
            backgroundColor: .B1,
            textColor: .white,
            fontSize: 18,
            text: sectionTitles[section].title
        )
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ArchivedCardCell.identifier,
            for: indexPath) as? ArchivedCardCell
        else {
            fatalError()
        }
        
        guard let section = AchievementSection(rawValue: indexPath.section) else { fatalError() }
        
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        
        switch section {
            
        case .archivedCards:
            
            cell.setupLayoutForGrowthCards()
            self.collectionViewForGrowthCards = cell.collectionView
            
        case .insights:
            
            cell.setupLayoutForInsight(width: tableView.frame.size.width)
            self.collectionViewForInsights = cell.collectionView
        }
        
        return cell
    }
    
}

// MARK: - Collection View -
extension AchievementViewController: UICollectionViewDelegate {
   
    func collectionView(_ collectionView: UICollectionView,
                        contextMenuConfigurationForItemAt indexPath: IndexPath,
                        point: CGPoint) -> UIContextMenuConfiguration? {
        
        switch collectionView {
            
        case collectionViewForGrowthCards:
            
            let unarchive = UIAction.setupAction(of: .unarchive) { _ in
                
                self.unarchiveGrowthCard(id: self.growthCards[indexPath.row].id)
            }
            
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { _ in
                UIMenu(title: "", children: [unarchive])
            })
            
        default:
            
            return nil
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        
        cell.animateFadeIn(delayOrder: indexPath.row)
    }
    
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
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
            
        case collectionViewForGrowthCards:
            
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: ArchivedCardCollectionViewCell.self),
                for: indexPath
            )

            guard let cardCell = cell as? ArchivedCardCollectionViewCell else { return cell }
            
            cardCell.setupCell(growthCard: growthCards[indexPath.row], index: indexPath.row)
            cardCell.rightArrowButton.addTarget(
                self,
                action: #selector(tapShowCardDetailButton(_:)),
                for: .touchUpInside
            )

            return cardCell
            
        case collectionViewForInsights:
            
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: InsightCollectionViewCell.self),
                for: indexPath
            )

            guard let insightCell = cell as? InsightCollectionViewCell else { return cell }
            
            let title = insightTitles[indexPath.row].title
            let data = insightDict[insightTitles[indexPath.row]] ?? "00"
            insightCell.setupCell(title: title, data: data)
            
            return insightCell
            
        default:
            
            return UICollectionViewCell.init()
        }
    }
    
}

extension AchievementViewController {
    
    func setupWelcomeCardView() {
        
        userViniImageView.alpha = 0
        welcomeTitleLabel.alpha = 0
        welcomeActionButton.alpha = 0
        
        userViniImageView.transform = .identity
        welcomeTitleLabel.transform = .identity
        welcomeActionButton.transform = .identity
        
        welcomeCardView.layer.cornerRadius = 25
        welcomeActionButton.setupCorner()
    }
    
    func setupNotificationCenterObserver() {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateUserNameLabel),
            name: Notification.Name(rawValue: "updateUserInfo"),
            object: nil
        )
    }
    
    @objc func updateUserNameLabel(notification: Notification) {
        
        if let userInfo = notification.userInfo,
           let user = userInfo["user"] as? User {
            
            welcomeTitleLabel.text = user.displayName + ",\n相信你擁有讓自己變得更好的能力。"
            userViniImageView.image = UIImage(named: user.viniType)
        }
    }
    
    func showWelcomeContentAnimation() {
        
        let yTransform = CGAffineTransform(translationX: 0, y: -10)
        
        UIView.animate(
            withDuration: 1.0,
            delay: 0.1,
            options: .curveEaseInOut,
            animations: {
                
                self.userViniImageView.alpha = 1
                self.welcomeTitleLabel.alpha = 1
                self.welcomeActionButton.alpha = 1
                self.userViniImageView.transform = yTransform
                self.welcomeTitleLabel.transform = yTransform
                self.welcomeActionButton.transform = yTransform
            },
            completion: nil
        )
    }
    
}
