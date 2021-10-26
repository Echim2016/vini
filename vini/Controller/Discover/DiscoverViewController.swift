//
//  DiscoverViewController.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/25.
//

import UIKit

class DiscoverViewController: UIViewController {
    
    var numberOfItems = 4
    
    var lastOffset: CGPoint = .zero
    var lastOffsetCapture: TimeInterval = .zero
    var isScrollingFast: Bool = false

    
    var colorBool : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupMapScrollView()
    }
    
}

extension DiscoverViewController {
    
    func setupMapScrollView() {
        
        let mapView = MapScrollView()
        
        self.view.addSubview(mapView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
}
