//
//  CustomTabBarController.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/11/10.
//

import UIKit
import AVFoundation

class CustomTabBarController: UITabBarController {
    
    var player: AVAudioPlayer?

    private let mailManager = MailManager.shared
    
    private let userManager = UserManager.shared

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
        
        playLightImpactVibration()
        
        switch item.title {
            
        case TabBarItem.achievement.title, TabBarItem.discover.title:
            
            fetchUserData()
            
        default:
            
            break
        }
    }
    
    func setupTabBarAppearance() {
        
        tabBar.layer.masksToBounds = true
        tabBar.isTranslucent = true
        tabBar.layer.cornerRadius = 25
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func setupTabBarItemTitle() {
        
        let tabBarItems = TabBarItem.allCases
        
        for index in 0..<tabBarItems.count {
            
            self.tabBar.items?[index].title = tabBarItems[index].title
        }
    }
    
    func setupSoundPlayer() {
        
        if let url = Bundle.main.url(forResource: "reflection", withExtension: "mp3") {
            
            player = try? AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1
            player?.volume = 0
            player?.play()
            player?.setVolume(0.2, fadeDuration: 3)
        }
    }
    
    func stopSound() {
        
        player?.setVolume(0, fadeDuration: 5)
    }

}

extension CustomTabBarController {
    
    func fetchMailsForBadgeValue() {
        
        mailManager.fetchNumberOfUnreadMails { result in
            
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
    
    func fetchUserData() {
        
        if let userID = UserManager.shared.userID {
            
            userManager.fetchUser(userID: userID) { result in
                
                switch result {
                    
                case .success(let user):
                    
                    NotificationCenter.default.post(
                        name: Notification.Name(rawValue: "updateUserInfo"),
                        object: nil,
                        userInfo: ["user": user]
                    )
                    
                case .failure(let error):
                    
                    print(error)
                }
            }
        }
    }
    
}
