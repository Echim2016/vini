//
//  CustomTabBarController.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/11/10.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupTabBarItemTitle()
        fetchMailsForBadgeValue()
    }
    
//    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//
//        if item.title == TabBarItem.mailbox.title {
//            
//            fetchMailsForBadgeValue()
//        }
//    }
    
    func setupTabBarItemTitle() {
        
        let tabBarItems = TabBarItem.allCases
        
        for index in 0..<tabBarItems.count {
            
            self.tabBar.items?[index].title = tabBarItems[index].title
        }
    }
    
    func fetchMailsForBadgeValue() {
        
        MailManager.shared.fetchNumberOfUnreadMails { result in
            switch result {
            case .success(let count):
                
                if let tabBarItems = self.tabBar.items {
                    let tabItem = tabBarItems[TabBarItem.mailbox.rawValue]
                    tabItem.badgeValue = count == 0 ? nil : "\(count)"
                }
                
            case .failure(let error):
                
                print(error)
            }
        }
    }

}
