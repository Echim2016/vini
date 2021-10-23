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
    }

    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var data: [GrowthCard] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setupNavigationController()
        
        tableView.registerCellWithNib(identifier: GrowthCardCell.identifier, bundle: nil)
        
        tableView.register(MyGrowthCardsHeader.self, forHeaderFooterViewReuseIdentifier: MyGrowthCardsHeader.identifier)
        
        fetchGrowthCards()
    }
    @IBAction func tapCreateNewGrowthCardButton(_ sender: Any) {
        
        performSegue(withIdentifier: "CreateNewGrowthCard", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
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
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 94/255, green: 121/255, blue: 161/255, alpha: 1)

        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
}

extension GrowthPageViewController {
    
    func fetchGrowthCards() {
        
        GrowthCardProvider.shared.fetchData { result in
            
            switch result {
            case .success(let cards):
                
                self.data = cards
                self.tableView.reloadData()
                
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
        
        header.titleLabel.text = "我的成長項目"
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        60
    }
}

extension GrowthPageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "ShowGrowthCapture", sender: indexPath.row)
    }
    
}
