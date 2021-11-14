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
        setupTabBarAppearance()
        fetchMailsForBadgeValue()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.frame.size.height = 95
        tabBar.frame.origin.y = view.frame.height - 95
    }
    
    func setupTabBarAppearance() {
        
        tabBar.layer.masksToBounds = true
        tabBar.isTranslucent = true
        tabBar.layer.cornerRadius = 25
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func setupTabBarItemTitle() {
        
        let tabBarItems = TabBarItem.allCases
        
        for index in 0..<tabBarItems.count {
            
            self.tabBar.items?[index].title = tabBarItems[index].title
        }
    }

}

extension CustomTabBarController {
    
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
