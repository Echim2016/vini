//
//  GrowthPageViewController.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/18.
//

import UIKit

class GrowthPageViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var data: [GrowthCard] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerCellWithNib(identifier: GrowthCardCell.identifier, bundle: nil)
        
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
    
}

extension GrowthPageViewController: UITableViewDelegate {
    
}
