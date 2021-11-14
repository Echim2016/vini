//
//  CustomTabBarController.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/11/10.
//

import UIKit
import Haptica

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
        tabBar.frame.size.height *= 1.15
        tabBar.frame.origin.y = view.frame.height - tabBar.frame.size.height
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        Haptic.play(".", delay: 0)
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
