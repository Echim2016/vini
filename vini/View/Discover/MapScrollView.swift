//
//  MapScrollView.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/26.
//

import UIKit

class MapScrollView: UIView {
    
    private var numberOfItems = 6
    
    let colors: [UIColor] = [.blue, .cyan, .brown, .darkGray, .S1, .purple]
    
    private let scrollView: UIScrollView = {
        
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.bounces = false
        scrollView.isPagingEnabled = false
        scrollView.decelerationRate = UIScrollView.DecelerationRate(rawValue: 0.1)
        return scrollView
    }()
    
    var mapStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.spacing = 0
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupStackView()
        scrollView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        
        self.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func setupStackView() {
        
        scrollView.addSubview(mapStackView)
        
        mapStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            mapStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            mapStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            mapStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
        ])
        
        for index in 0..<numberOfItems {
            
            let defaultMapView = UIView()
            mapStackView.addArrangedSubview(defaultMapView)
            defaultMapView.translatesAutoresizingMaskIntoConstraints = false
            defaultMapView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor).isActive = true
            defaultMapView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor).isActive = true
            defaultMapView.backgroundColor = colors[index]
        }
    }
}

extension MapScrollView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard scrollView.frame.size.width > 0 else { return }
                
        let currentPage: Int = Int(scrollView.contentOffset.x / scrollView.frame.size.width)

        if scrollView.panGestureRecognizer.translation(in: scrollView.superview).x > 0 {
                        
            if currentPage == 1 {
                
                print("Add Left New Map")
                
                let newMapView = UIView()
                
                let random = Int.random(in: 0...5)
                
                newMapView.backgroundColor = colors[random]
                
                mapStackView.insertArrangedSubview(newMapView, at: 0)
                
                newMapView.translatesAutoresizingMaskIntoConstraints = false
                
                newMapView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor).isActive = true
                
                newMapView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor).isActive = true

                let viewToRemove = mapStackView.arrangedSubviews[numberOfItems - 2]
                
                mapStackView.removeArrangedSubview(viewToRemove)
                
                viewToRemove.removeFromSuperview()
                
                scrollView.contentOffset.x += viewToRemove.frame.width
            }
            
        } else {
            
            if currentPage == numberOfItems - 2 {
                
                print("Add Right New Map")
                
                let newMapView = UIView()
                
                let random = Int.random(in: 0...5)
                
                newMapView.backgroundColor = colors[random]
                
                mapStackView.addArrangedSubview(newMapView)
                
                newMapView.translatesAutoresizingMaskIntoConstraints = false
                
                newMapView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor).isActive = true
                
                newMapView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor).isActive = true
                                
                let viewToRemove = mapStackView.arrangedSubviews[1]
                
                mapStackView.removeArrangedSubview(viewToRemove)
                
                viewToRemove.removeFromSuperview()
                
                scrollView.contentOffset.x -= viewToRemove.frame.width
            }
        }
    }
    
}
