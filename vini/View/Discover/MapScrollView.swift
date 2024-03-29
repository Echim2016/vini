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

protocol MapScrollViewDelegate: AnyObject {
    
    func didReachedRightEdge()
    func didReachedLeftEdge()
}

class MapScrollView: UIView {
    
    private var numberOfMapsInStack = 6
    
    private var numberOfViniPerMap = 3
    
    let colors: [UIColor] = [.blue, .cyan, .brown, .darkGray, .S1, .purple]
    
    weak var dataSource: MapScrollViewDataSource?
    
    weak var delegate: MapScrollViewDelegate?
    
    private var infosOfUsers: [ViniView] = []
    
    var currentDataLocation: Int = 0
    
    let scrollView: UIScrollView = {
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
        stack.distribution = .fillEqually
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
                
                self.currentDataLocation = infosOfUsers.count / 2 - 1
            } else {
                self.currentDataLocation = 0
            }
            
//            print("current data location = \(currentDataLocation)")
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
            
            let isReachingLeftEdge = scrollView.contentOffset.x == 0
            
            if isReachingLeftEdge {
                
                delegate?.didReachedLeftEdge()
            }
                        
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
                                
                var offset = numberOfViniPerMap
                
                if currentDataLocation < numberOfViniPerMap {
                    
                    offset = currentDataLocation
                }
                
                for index in currentDataLocation - offset ..< currentDataLocation {
                    
                    let data = infosOfUsers[index]
                    vinis.append(data)
                    currentDataLocation -= 1
                }
                
                mapStackView.arrangedSubviews[1].spawnViniRandomly(vinis: vinis)
                                
                let viewToRemove = mapStackView.arrangedSubviews[numberOfMapsInStack - 2]
                
                mapStackView.removeArrangedSubview(viewToRemove)
                
                viewToRemove.removeFromSuperview()
                
                scrollView.contentOffset.x += viewToRemove.frame.width
            }
            
        } else {
            
            let isReachingRightEdge = scrollView.contentOffset.x >= 0
                 && scrollView.contentOffset.x >= (scrollView.contentSize.width - scrollView.frame.size.width)
            
            if isReachingRightEdge {
                
                delegate?.didReachedRightEdge()
            }
            
            if currentPage == numberOfMapsInStack - 3 && currentDataLocation < infosOfUsers.count {
                                
                let newMapView = UIView()
                
//                let random = Int.random(in: 0...5)
//                newMapView.backgroundColor = colors[random]
                newMapView.backgroundColor = .clear
                mapStackView.addArrangedSubview(newMapView)
    
                newMapView.translatesAutoresizingMaskIntoConstraints = false
                newMapView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor).isActive = true
                newMapView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor).isActive = true
                
                var vinis: [ViniView] = []
                                
                var offset = numberOfViniPerMap
                
                if infosOfUsers.count - currentDataLocation < numberOfViniPerMap {
                    
                    offset = (infosOfUsers.count - currentDataLocation) % numberOfViniPerMap
                }
                
                for index in currentDataLocation ..< currentDataLocation + offset {
                    
                    let data = infosOfUsers[index]
                    vinis.append(data)
                    currentDataLocation += 1
                }
                
                mapStackView.arrangedSubviews[numberOfMapsInStack - 2].spawnViniRandomly(vinis: vinis)
                
                let viewToRemove = mapStackView.arrangedSubviews[1]
                mapStackView.removeArrangedSubview(viewToRemove)
                viewToRemove.removeFromSuperview()
                scrollView.contentOffset.x -= viewToRemove.frame.width
            }
        }
    }
    
}

extension UIView {
    
    func spawnViniRandomly(vinis: [ViniView]) {
        
        let numberOfVinis = vinis.count
        
        self.clipsToBounds = true

        // Get Width and Height of view
        let width = self.frame.width - 100
        let height = self.frame.height - 120
        
        var positions: [(Int, Int)] = [
           (Int.random(in: 0...Int(width)),
            Int.random(in: 210...Int(height)))
        ]
        
        var randomX = 0
        var randomY = 0
        
        for _ in 0..<numberOfVinis {
            
            var exist = false
            
            var count = 0
            
            while !exist || count > 100000 {
                
                let widthSpacing = count > 50000 ? 10 : 50
                let heightSpacing = count > 50000 ? 10 : 60
                
                randomX = Int.random(in: 0...Int(width))
                randomY = Int.random(in: 210...Int(height))
                
                for position in positions {
                    if abs(randomX - position.0) > widthSpacing && abs(randomY - position.1) > heightSpacing {
                        exist = true
                    } else {
                        exist = false
                        break
                    }
                }
                
                count += 1
            }
            
            positions.append((randomX, randomY))
        }
        
        for index in 0..<numberOfVinis {
            
            let viniView = ViniView(frame: CGRect(x: positions[index].0, y: positions[index].1, width: 80, height: 100))
            viniView.data.id = vinis[index].data.id
            viniView.data.name = vinis[index].data.name
            viniView.data.wondering = vinis[index].data.wondering
            viniView.viniImageView.image = UIImage(named: vinis[index].data.viniType)
            
            self.addSubview(viniView)
        }
    }
    
}
