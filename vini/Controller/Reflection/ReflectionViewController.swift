//
//  ReflectionViewController.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/11/3.
//

import UIKit

class ReflectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.isPagingEnabled = true
            collectionView.decelerationRate = UIScrollView.DecelerationRate(rawValue: 0.2)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.registerCellWithNib(identifier: ReflectionIntroCell.identifier, bundle: nil)
        collectionView.registerCellWithNib(identifier: ReflectionPracticeCell.identifier, bundle: nil)
        collectionView.registerCellWithNib(identifier: ReflectionOutroCell.identifier, bundle: nil)
        setupLayoutForReflection()
        
        self.tabBarController?.tabBar.isHidden = true
        modalPresentationCapturesStatusBarAppearance = true
        
        self.additionalSafeAreaInsets = UIEdgeInsets(top: -44, left: 0, bottom: -34, right: 0)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func tapContinueButton(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ReflectionViewController: UICollectionViewDelegate {
    
}

extension ReflectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                
        switch indexPath.row {
        case 0:
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ReflectionIntroCell.identifier
,
                for: indexPath
            ) as? ReflectionIntroCell else {
                fatalError()
            }
            
            return cell
            
        case 1:
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ReflectionPracticeCell.identifier
,
                for: indexPath
            ) as? ReflectionPracticeCell else {
                fatalError()
            }
            
            return cell
            
        case 2:
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ReflectionOutroCell.identifier
,
                for: indexPath
            ) as? ReflectionOutroCell else {
                fatalError()
            }
            
            cell.outroCloudImageView.float(duration: 0.8)
            cell.continueButton.addTarget(self, action: #selector(tapContinueButton(_:)), for: .touchUpInside)
            
            return cell
            
        default:
            return UICollectionViewCell()
            
        }
        
    }
    
}

extension ReflectionViewController {
    
    func setupLayoutForReflection() {
        
        let flowLayout = UICollectionViewFlowLayout()

        flowLayout.itemSize = CGSize(
            width: Int(self.view.frame.size.width) ,
            height: Int(self.view.frame.size.height)
        )

        flowLayout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)

        flowLayout.minimumInteritemSpacing = 0

        flowLayout.minimumLineSpacing = 0.0
        
        flowLayout.scrollDirection = .vertical

        collectionView.collectionViewLayout = flowLayout
    }

}
