//
//  ArchivedCardCell.swift
//  vini
//
//  Created by Yi-Chin Hsu on 2021/11/2.
//

import UIKit

class ArchivedCardCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        collectionView.backgroundColor = .clear
        
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    func setupLayoutForGrowthCards() {
        
        collectionView.registerCellWithNib(
            identifier: String(describing: ArchivedCardCollectionViewCell.self),
            bundle: nil
        )
                
        let flowLayout = UICollectionViewFlowLayout()

        flowLayout.itemSize = CGSize(
            width: Int(2.0 / 3.0 * self.collectionView.frame.width) ,
            height: Int(self.collectionView.frame.height)
        )

        flowLayout.sectionInset = UIEdgeInsets(top: 5.0, left: 0.0, bottom: 24.0, right: 16.0)

        flowLayout.minimumInteritemSpacing = 0

        flowLayout.minimumLineSpacing = 24.0
        
        flowLayout.scrollDirection = .horizontal

        collectionView.collectionViewLayout = flowLayout
    }
    
    func setupLayoutForInsight(width: CGFloat) {
        
        collectionView.registerCellWithNib(
            identifier: String(describing: InsightCollectionViewCell.self),
            bundle: nil
        )
                
        let flowLayout = UICollectionViewFlowLayout()

        flowLayout.itemSize = CGSize(
            width: Int((width - 45) * 0.5),
            height: Int((width - 45) * 0.5)
        )

        flowLayout.sectionInset = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)

        flowLayout.minimumInteritemSpacing = 3.0

        flowLayout.minimumLineSpacing = 5.0
        
        flowLayout.scrollDirection = .vertical

        collectionView.collectionViewLayout = flowLayout
    }
    
}
