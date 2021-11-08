//
//  DiscoverMapViewController.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/11/8.
//

import UIKit

class DiscoverMapViewController: UIViewController {

    @IBOutlet weak var modalBackgroundView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.isPagingEnabled = true
            collectionView.isScrollEnabled = false
        }
    }
    @IBOutlet weak var leftArrowButton: UIButton!
    @IBOutlet weak var rightArrowButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    var currentSelectedIndex: CGFloat = 0 {
        didSet {
            
            if currentSelectedIndex > 3 {
                currentSelectedIndex = 3
            }
            
            if currentSelectedIndex < 0 {
                currentSelectedIndex = 0
            }
            
            let contenOffset = CGPoint(
                x: collectionView.frame.width * currentSelectedIndex,
                y: collectionView.contentOffset.y)
            
            collectionView.setContentOffset(contenOffset, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isModalInPresentation = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        modalBackgroundView.layer.cornerRadius = 25
        leftArrowButton.layer.cornerRadius = 25
        rightArrowButton.layer.cornerRadius = 25
        cancelButton.layer.cornerRadius = 18
        confirmButton.layer.cornerRadius = 18
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupCollectionViewLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        currentSelectedIndex = 0
    }
    
    
    @IBAction func tapLeftArrowButton(_ sender: Any) {
        
        currentSelectedIndex -= 1
    }
    
    @IBAction func tapRightArrowButton(_ sender: Any) {
        
        currentSelectedIndex += 1
    }
    
    
    @IBAction func tapCancelButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapConfirmButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension DiscoverMapViewController: UICollectionViewDelegate {
    
   
    
}

extension DiscoverMapViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: MapCategoryCell.self),
            for: indexPath
        )

        guard let mapCell = cell as? MapCategoryCell else {
            return cell
        }
        
        if indexPath.row == 1 {
            mapCell.mapBackgroundView.backgroundColor = .S1
        }
        
        return mapCell
    }
    
    
    func setupCollectionViewLayout() {
        
        collectionView.registerCellWithNib(
            identifier: String(describing: MapCategoryCell.self),
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
