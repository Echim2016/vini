//
//  MapScrollView.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/10/26.
//

import UIKit

protocol MapScrollViewDataSource: AnyObject {
    
    func infoOfUsers(_ mapScrollView: MapScrollView) -> [ViniView]
}

class MapScrollView: UIView {
    
    private var numberOfMapsInStack = 6
    
    private var numberOfViniPerMap = 3
    
    let colors: [UIColor] = [.blue, .cyan, .brown, .darkGray, .S1, .purple]
    
    weak var dataSource: MapScrollViewDataSource?
    
    private var infosOfUsers: [ViniView] = []
    
    var currentDataLocation: Int = 0
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.bounces = false
        scrollView.isPagingEnabled = false
        scrollView.decelerationRate = UIScrollView.DecelerationRate(rawValue: 0.5)
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
        self.isUserInteractionEnabled = false
        scrollView.delegate = self
        setupSubviews()
        setupStackView()
        configureMapScrollView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureMapScrollView() {
        
        mapStackView.arrangedSubviews.forEach { view in
            view.subviews.forEach { subview in
                if let vini = subview as? ViniView {
                    vini.removeFromSuperview()
                }
            }
        }
        
        if let infos = dataSource?.infoOfUsers(self) {
            self.infosOfUsers = infos
            
            if infosOfUsers.count >= numberOfMapsInStack {
                self.currentDataLocation = infosOfUsers.count / numberOfViniPerMap / 2 - 1
            } else {
                self.currentDataLocation = 0
            }
        }
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
        
        for index in 0..<numberOfMapsInStack {
            
            let defaultMapView = UIView()
            mapStackView.addArrangedSubview(defaultMapView)
            defaultMapView.clipsToBounds = false
            defaultMapView.translatesAutoresizingMaskIntoConstraints = false
            defaultMapView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor).isActive = true
            defaultMapView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor).isActive = true
//            defaultMapView.backgroundColor = colors[index]
            defaultMapView.backgroundColor = .clear
            
        }
        
    }
   
    func setContentOffsetToMiddle() {
        
        scrollView.contentOffset.x = scrollView.frame.size.width * CGFloat(numberOfMapsInStack) / 2
    }
    
    func clearStackSubviews() {
        
        mapStackView.arrangedSubviews[numberOfMapsInStack / 2].subviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
}

extension MapScrollView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard scrollView.frame.size.width > 0 else { return }
              
        guard infosOfUsers.count > 0 else { return }
                
        let currentPage: Int = Int(scrollView.contentOffset.x / scrollView.frame.size.width)

        // user swipe to left
        if scrollView.panGestureRecognizer.translation(in: scrollView.superview).x > 0 {
                        
            if currentPage == 1 && currentDataLocation > 0 {
                                
                let newMapView = UIView()
                
//                let random = Int.random(in: 0...5)
//                newMapView.backgroundColor = colors[random]
                newMapView.backgroundColor = .clear
                mapStackView.insertArrangedSubview(newMapView, at: 0)
                newMapView.translatesAutoresizingMaskIntoConstraints = false
                newMapView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor).isActive = true
                newMapView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor).isActive = true
                
                var vinis: [ViniView] = []
                
                let location = currentDataLocation * numberOfViniPerMap
                
                for index in location ..< location + numberOfViniPerMap {
                    
                    if infosOfUsers.count > index {
                        let data = infosOfUsers[index]
                        vinis.append(data)
                    } else {
                        // fetch new data
                    }
                }
                
                if vinis.count == numberOfViniPerMap {
                    mapStackView.arrangedSubviews[1].spawnViniRandomly(vinis: vinis)
                }
                                
                let viewToRemove = mapStackView.arrangedSubviews[numberOfMapsInStack - 2]
                
                mapStackView.removeArrangedSubview(viewToRemove)
                
                viewToRemove.removeFromSuperview()
                
                scrollView.contentOffset.x += viewToRemove.frame.width
                
                currentDataLocation -= 1
            }
            
        } else {
            
            if currentPage == numberOfMapsInStack - 3 && (currentDataLocation + 1) * numberOfViniPerMap < infosOfUsers.count {
                                
                let newMapView = UIView()
                
//                let random = Int.random(in: 0...5)
//                newMapView.backgroundColor = colors[random]
                newMapView.backgroundColor = .clear
                mapStackView.addArrangedSubview(newMapView)
    
                newMapView.translatesAutoresizingMaskIntoConstraints = false
                newMapView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor).isActive = true
                newMapView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor).isActive = true
                
                var vinis: [ViniView] = []
                
                let location = currentDataLocation * numberOfViniPerMap
                
                for index in location ..< location + numberOfViniPerMap {
                    
                    if infosOfUsers.count > index {
                        let data = infosOfUsers[index]
                        vinis.append(data)
                    }
                }
                if vinis.count == numberOfViniPerMap {
                    mapStackView.arrangedSubviews[numberOfMapsInStack - 2].spawnViniRandomly(vinis: vinis)
                }
            
                let viewToRemove = mapStackView.arrangedSubviews[1]
                mapStackView.removeArrangedSubview(viewToRemove)
                viewToRemove.removeFromSuperview()
                scrollView.contentOffset.x -= viewToRemove.frame.width
                
                currentDataLocation += 1
            }
        }
    }
    
}

extension UIView {
    
    func spawnViniRandomly(vinis: [ViniView]) {
        
        let numberOfVinis = vinis.count - 1
        
        self.clipsToBounds = true

        // Get Width and Height of view
        let width = self.frame.width - 100
        let height = self.frame.height - 120
        
        var positions: [(Int, Int)] = [
           (Int.random(in: 0...Int(width)),
            Int.random(in: 224...Int(height)))
        ]
        
        var randomX = 0
        var randomY = 0
        
        for _ in 0...numberOfVinis - 1 {
            
            var exist = false
            
            while !exist {
                
                randomX = Int.random(in: 0...Int(width))
                randomY = Int.random(in: 224...Int(height))
                
                for position in positions {
                    if abs(randomX - position.0) > 40 && abs(randomY - position.1) > 62 {
                        exist = true
                    } else {
                        exist = false
                        break
                    }
                }
            }
            
            positions.append((randomX, randomY))
        }
        
        for index in 0...numberOfVinis {
            
            let viniView = ViniView(frame: CGRect(x: positions[index].0, y: positions[index].1, width: 80, height: 100))
            viniView.data.id = vinis[index].data.id
            viniView.data.name = vinis[index].data.name
            viniView.data.wondering = vinis[index].data.wondering
            viniView.viniImageView.image = UIImage(named: vinis[index].data.viniType)
            
            self.addSubview(viniView)
        }
    }
    
}
