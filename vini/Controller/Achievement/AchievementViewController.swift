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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerCellWithNib(identifier: ArchivedCardCell.identifier, bundle: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationController(title: "成就")
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
        100
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
            return 5
        case collectionViewForInsights:
            return 4
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
            let data = "43"
            insightCell.setupCell(title: title, data: data)
            
            return insightCell
            
        default:
            return UICollectionViewCell.init()
        }
        
    }
    
}
