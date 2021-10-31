//
//  DiscoverViewController.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/25.
//

import UIKit
import Haptica

class DiscoverViewController: UIViewController {
    
    private enum Segue: String {
        
        case showProfileSetting = "ShowProfileSetting"
        case showSendMailPage = "ShowSendMailPage"
    }
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    
    let mapView = MapScrollView()
    
    private var infoOfUsers: [ViniView] = []
        
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var wonderingLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    
    var currentSelectedVini: ViniView = ViniView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupMapScrollView()
        setupNavigationController(title: "探索")
        fetchUserInfo()
        headerView.layer.cornerRadius = 25
        sendButton.layer.cornerRadius = 20
        
//        headerView.float(duration: 1)        backgroundImageView.float(duration: 5)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.mapView.spawnDefaultVinis()
            self.mapView.setContentOffsetToMiddle()
        })
        
        print(mapView.frame.width)
        print(mapView.frame.height)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        mapView.clearStackSubviews()
        resetTitle()
    }
    
    @objc private func onTap(_ gesture: UIGestureRecognizer) {

        let touchPoint = gesture.location(in: self.mapView.mapStackView)
                
        self.mapView.mapStackView.arrangedSubviews.filter { $0.frame.contains(touchPoint)}.forEach { map  in
            
            let location = gesture.location(in: map)
            
            map.subviews.filter {$0.frame.contains(location)}.forEach { vini in
                if let vini = vini as? ViniView {
                    sendButton.alpha = 1
                    vini.isUserInteractionEnabled = false
                    
                    if let userID = UserDefaults.standard.value(forKey: "id") as? String {
                        
                        if vini.data.id == userID {
                            sendButton.alpha = 0
                        }
                    }
                    
                    nameLabel.text = vini.data.name
                    wonderingLabel.text = vini.data.wondering
                    
                    if self.currentSelectedVini != vini {
                        
                        vini.float(duration: 0.5)
                        self.currentSelectedVini.layer.removeAllAnimations()
                        self.currentSelectedVini.isUserInteractionEnabled = true
                        self.currentSelectedVini = vini
                        Haptic.play(".", delay: 0.1)
                    }
                    
                }
            }
            
        }
    }
    
    @IBAction func tapProfileSettingButton(_ sender: Any) {

        performSegue(withIdentifier: Segue.showProfileSetting.rawValue, sender: nil)
    }
    
    @IBAction func tapSendMailButton(_ sender: Any) {
        
        performSegue(withIdentifier: Segue.showSendMailPage.rawValue, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? SendMailViewController {
            
            destination.receipient = currentSelectedVini
        }
    }
    
}

extension DiscoverViewController {
    
    func setupMapScrollView() {
        
        mapView.dataSource = self
        
        self.view.addSubview(mapView)
                
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))

        self.mapView.addGestureRecognizer(tapGesture)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mapView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 1)
        ])
    }
    
    func resetTitle() {
        
        wonderingLabel.text = "歡迎回來 Vini Town，\n繼續探索吧！"
        nameLabel.text = "請左滑或右滑開始探索"
        sendButton.alpha = 0
    }
}

extension DiscoverViewController {
    
    func fetchUserInfo() {
        
        DiscoverUserManager.shared.fetchData { result in
            switch result {
            case .success(let vinis):
                
                self.infoOfUsers = vinis
                self.mapView.configureMapScrollView()

            case .failure(let error):
                
                print(error)
            }
        }
    }
    
}

extension DiscoverViewController: MapScrollViewDataSource {
    
    func infoOfUsers(_ mapScrollView: MapScrollView) -> [ViniView] {
        return infoOfUsers
    }
    
}
