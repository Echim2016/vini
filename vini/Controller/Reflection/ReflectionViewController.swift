//
//  ReflectionViewController.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/11/3.
//

import UIKit
import Haptica

class ReflectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.isPagingEnabled = true
            collectionView.decelerationRate = UIScrollView.DecelerationRate(rawValue: 0.2)
        }
    }
    
    var quoteList: [String] = []
    
    var isVisited = false
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchReflectionData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupWelcomeAnimation()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func tapContinueButton(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
}

extension ReflectionViewController  {
    
    func fetchReflectionData() {
        
        ReflectionManager.shared.fetchQuestions { result in
            
            switch result {
                
            case .success(let list):
                
                self.quoteList = list
                self.collectionView.reloadData()
                
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
}

extension ReflectionViewController: UICollectionViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let page = Int(scrollView.contentOffset.y / self.view.frame.height)
        
        if page == 1 && !isVisited {
            
            collectionView.isScrollEnabled = false
        }
        
        Haptic.play(".", delay: 0)
    }
    
}

extension ReflectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                
        switch indexPath.row {
        case 0:
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReflectionIntroCell.identifier, for: indexPath) as? ReflectionIntroCell else {
                fatalError()
            }
            
            return cell
            
        case 1:
            
            guard let cell = collectionView.dequeueReusableCell( withReuseIdentifier: ReflectionPracticeCell.identifier, for: indexPath) as? ReflectionPracticeCell else {
                fatalError()
            }
            
            cell.delegate = self
            cell.setupCell(quotes: quoteList)
            
            return cell
            
        case 2:
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReflectionOutroCell.identifier, for: indexPath) as? ReflectionOutroCell else {
                fatalError()
            }
            
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

extension ReflectionViewController {
    
    func setupWelcomeAnimation() {
        
        guard let cell = collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? ReflectionIntroCell else {
            return
        }
        
        cell.setupTitleAnimation()
    }
}
