//
//  UICollectionView+Extension.swift
//  FlickerSearch
//
//  Created by Abdul Basit on 17/07/2020.
//  Copyright © 2020 Abdul Basit. All rights reserved.
//

import UIKit

extension UICollectionView {
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to Dequeue Reusable Table View Cell")
        }
        return cell
    }
    
    func sizeForItem(numberOfCellsInRow: Int, collectionViewLayout: UICollectionViewLayout) -> CGSize {
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            
            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(numberOfCellsInRow - 1))
            
            let size = Double((self.bounds.width - totalSpace) / CGFloat(numberOfCellsInRow))
            
            return CGSize(width: size, height: (size + 30.0))
        }
        return .zero
    }
}
