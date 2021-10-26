//
//  DiscoverViewController.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/25.
//

import UIKit

class DiscoverViewController: UIViewController {
    
    let mapView = MapScrollView()
        
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupMapScrollView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.mapView.spawnDefaultVinis()
            self.mapView.setContentOffsetToMiddle()
        })
    }

}

extension DiscoverViewController {
    
    func setupMapScrollView() {
        
        self.view.addSubview(mapView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mapView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.7)
        ])
    }
    
}
