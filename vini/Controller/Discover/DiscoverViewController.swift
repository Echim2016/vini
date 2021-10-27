//
//  DiscoverViewController.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/25.
//

import UIKit

class DiscoverViewController: UIViewController {
    
    let mapView = MapScrollView()
    
    private var infoOfUsers: [Vini] = []
        
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var wonderingLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.isUserInteractionEnabled = true
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupMapScrollView()
        fetchUserInfo()
        headerView.layer.cornerRadius = 25
        sendButton.layer.cornerRadius = 20
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.mapView.spawnDefaultVinis()
            self.mapView.setContentOffsetToMiddle()
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        mapView.clearStackSubviews()
    }
    
    @objc private func onTap(_ gesture: UIGestureRecognizer) {

        let touchPoint = gesture.location(in: self.mapView.mapStackView)
        
        print(touchPoint)
        
        self.mapView.mapStackView.arrangedSubviews.filter { $0.frame.contains(touchPoint)}.forEach { map  in
            
            let location = gesture.location(in: map)
            
            map.subviews.filter {$0.frame.contains(location)}.forEach { vini in
                if let vini = vini as? Vini {
                    sendButton.alpha = 1
                    vini.layer.removeAllAnimations()
//                    vini.shake()
                    vini.float(duration: 0.5)
                    print(vini.name)
                    nameLabel.text = vini.name
                    wonderingLabel.text = vini.wondering
                    
                }
            }
            
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
            mapView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.7)
        ])
    }
    
}

extension DiscoverViewController {
    
    func fetchUserInfo() {
        
        DiscoverUserManager.shared.fetchData { result in
            switch result {
            case .success(let vinis):
                
                self.infoOfUsers = vinis
                self.mapView.configureMapScrollView()
                
                self.infoOfUsers.forEach { vini in
                    print(vini.name)
                }

            case .failure(let error):
                
                print(error)
            }
        }
        
    }
    
}

extension DiscoverViewController: MapScrollViewDataSource {
    
    func infoOfUsers(_ mapScrollView: MapScrollView) -> [Vini] {
        return infoOfUsers
    }
    
}
