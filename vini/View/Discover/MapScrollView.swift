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
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
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
            mapStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
        ])
        
        for index in 0..<numberOfItems {
            
            let defaultMapView = UIView()
            mapStackView.addArrangedSubview(defaultMapView)
            defaultMapView.translatesAutoresizingMaskIntoConstraints = false
            defaultMapView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor).isActive = true
            defaultMapView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor).isActive = true
            defaultMapView.backgroundColor = colors[index]
            defaultMapView.backgroundColor = .B2
            
        }
        
    }
    
    func spawnDefaultVinis() {
        
        mapStackView.arrangedSubviews[numberOfItems / 2].spawnViniRandomly()
    }
    
    func setContentOffsetToMiddle() {
        
        scrollView.contentOffset.x = scrollView.frame.size.width * CGFloat(numberOfItems) / 2
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
                
                newMapView.backgroundColor = .B2
                
                mapStackView.insertArrangedSubview(newMapView, at: 0)
                
                newMapView.translatesAutoresizingMaskIntoConstraints = false
                
                newMapView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor).isActive = true
                
                newMapView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor).isActive = true
                                
                mapStackView.arrangedSubviews[1].spawnViniRandomly()

                let viewToRemove = mapStackView.arrangedSubviews[numberOfItems - 2]
                
                mapStackView.removeArrangedSubview(viewToRemove)
                
                viewToRemove.removeFromSuperview()
                
                scrollView.contentOffset.x += viewToRemove.frame.width
            }
            
        } else {
            
            if currentPage == numberOfItems - 3 {
                
                print("Add Right New Map")
                
                let newMapView = UIView()
                
                let random = Int.random(in: 0...5)
                
                newMapView.backgroundColor = colors[random]
                
                newMapView.backgroundColor = .B2
                
                mapStackView.addArrangedSubview(newMapView)
                
                newMapView.translatesAutoresizingMaskIntoConstraints = false
                
                newMapView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor).isActive = true
                
                newMapView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor).isActive = true
                                                
                mapStackView.arrangedSubviews[numberOfItems - 2].spawnViniRandomly()
                                
                let viewToRemove = mapStackView.arrangedSubviews[1]
                
                mapStackView.removeArrangedSubview(viewToRemove)
                
                viewToRemove.removeFromSuperview()
                
                scrollView.contentOffset.x -= viewToRemove.frame.width
            }
        }
    }
    
}

extension UIView {
    
    func spawnViniRandomly() {
        
        let numberOfVinis = 2
        
        self.clipsToBounds = true

        // Get Width and Height of view
        let width = self.frame.width - 100
        let height = self.frame.height - 120
        
        var positions: [(Int, Int)] = [(Int(arc4random_uniform(UInt32(width))), Int(arc4random_uniform(UInt32(height))))]
        var randomX = 0
        var randomY = 0
        
        for _ in 0..<numberOfVinis {
            
            var exist = false
            
            while !exist {
                
                randomX = Int(arc4random_uniform(UInt32(width)))
                randomY = Int(arc4random_uniform(UInt32(height)))
                
                for position in positions {
                    if abs(randomX - position.0) > 40 && abs(randomY - position.1) > 60 {
                        exist = true
                    } else {
                        exist = false
                        break
                    }
                }
                                
            }
            
            positions.append((randomX, randomY))
        }
        
        for (randomX, randomY) in positions {
            
            let randomView = UIImageView(frame: CGRect(x: randomX, y: randomY, width: 80, height: 100))
            randomView.contentMode = .scaleAspectFit
            randomView.image = UIImage(named: "vini_spark")
            randomView.float(duration: 0.5)
            
            self.addSubview(randomView)
        }
    }
    
}
