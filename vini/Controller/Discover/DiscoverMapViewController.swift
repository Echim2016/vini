//
//  DiscoverMapViewController.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/11/8.
//

import UIKit
import Haptica

protocol DiscoverProtocol: AnyObject {
    
    func didSelectCloudCategory(_ category: CloudCategory)
    
    func willDisplayDiscoverPage()
}

class DiscoverMapViewController: UIViewController {

    @IBOutlet weak var modalBackgroundView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.isPagingEnabled = true
            collectionView.isScrollEnabled = false
            collectionView.decelerationRate = UIScrollView.DecelerationRate(rawValue: 0.5)
        }
    }
    @IBOutlet weak var leftArrowButton: UIButton!
    @IBOutlet weak var rightArrowButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    weak var delegate: DiscoverProtocol?
    
    var currentSelectedCategory: CloudCategory = .career
    
    var currentSelectedIndex: Int = 0 {
        didSet {
            
            if currentSelectedIndex > mapCategory.count - 1 {
                currentSelectedIndex = 0
            }
            
            if currentSelectedIndex < 0 {
                currentSelectedIndex = mapCategory.count - 1
            }
                        
            currentSelectedCategory = mapCategory[currentSelectedIndex]
                        
            let contenOffset = CGPoint(
                x: collectionView.frame.width * CGFloat(currentSelectedIndex),
                y: collectionView.contentOffset.y)
            
            collectionView.setContentOffset(contenOffset, animated: false)
        }
    }
    
    let mapCategory: [CloudCategory] = CloudCategory.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isModalInPresentation = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupBlurBackground(layer: 2)
        modalBackgroundView.layer.cornerRadius = 25
        leftArrowButton.layer.cornerRadius = 25
        rightArrowButton.layer.cornerRadius = 25
        cancelButton.layer.cornerRadius = 18
        confirmButton.layer.cornerRadius = 18
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupCollectionViewLayout()
        currentSelectedIndex = mapCategory.firstIndex(of: currentSelectedCategory) ?? 0
    }
    
    @IBAction func tapLeftArrowButton(_ sender: Any) {
        
        Haptic.play(".", delay: 0)
        currentSelectedIndex -= 1
    }
    
    @IBAction func tapRightArrowButton(_ sender: Any) {
        
        Haptic.play(".", delay: 0)
        currentSelectedIndex += 1
    }
    
    @IBAction func tapCancelButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapConfirmButton(_ sender: Any) {
        
        delegate?.didSelectCloudCategory(currentSelectedCategory)
        Haptic.play(".-.", delay: 0.3)
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension DiscoverMapViewController: UICollectionViewDelegate {
    
}

extension DiscoverMapViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        mapCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: CloudCategoryCell.self),
            for: indexPath
        )

        guard let mapCell = cell as? CloudCategoryCell else {
            return cell
        }
        
        mapCell.setupCell(category: mapCategory[indexPath.row])

        return mapCell
    }
    
    func setupCollectionViewLayout() {
        
        collectionView.registerCellWithNib(
            identifier: String(describing: CloudCategoryCell.self),
            bundle: nil
        )
                
        let flowLayout = UICollectionViewFlowLayout()

        flowLayout.itemSize = CGSize(
            width: Int(self.collectionView.frame.size.width),
            height: Int(self.collectionView.frame.size.height)
        )

        flowLayout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = flowLayout
    }
    
}
