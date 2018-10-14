//
//  TCMainCollectionDataDelegate.swift
//  TCMS
//
//  Created by Austin Chen on 2018-01-31.
//  Copyright © 2018 Austin Chen. All rights reserved.
//

import UIKit

class TCMainCollectionDataDelegate: NSObject {
    var vc: TCMainViewController
    
    init?(fromViewController vc: UIViewController) {
        guard let v = vc as? TCMainViewController else { return nil }
        self.vc = v
    }
}

extension TCMainCollectionDataDelegate: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vc.featuredEvents.first?.images.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "kCollectionCell", for: indexPath) as! TCMainTopCollectionCell
        
        if let path = vc.featuredEvents.first?.images[indexPath.row].path {
            cell.imgView.sdSetImage(withString: path)
        }
        return cell
    }
    
    // hightlight animation
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        UIView.animate(withDuration: 0.15, animations: {
            cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        UIView.animate(withDuration: 0.15, animations: {
            cell.transform = CGAffineTransform.identity
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // push using segue
    }
}


extension TCMainCollectionDataDelegate: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: kAccountCarouselXMargin, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: kAccountCarouselXMargin, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: kAccountCarouselWidth, height: kAccountCarouselHeight)
    }
}


extension TCMainCollectionDataDelegate: UIScrollViewDelegate {
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                          withVelocity velocity: CGPoint,
                                          targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        // Auto snapping of cells to tbaleview top
        // assume first cell's width represent all cell width
        let x = targetContentOffset.pointee.x + scrollView.contentInset.top + (kAccountCarouselWidth / 2)
        let cellIndex = floor(x / kAccountCarouselWidth)
        targetContentOffset.pointee.x = cellIndex * (kAccountCarouselWidth + kAccountCarouselXMargin) - scrollView.contentInset.top
        
        vc.pageControl.currentPage = Int(cellIndex)
    }
}

let kAccountCarouselWidthHeightRatio: CGFloat = 374.0 / 210.0
let kAccountCarouselXMargin: CGFloat = 20.0
let kAccountCarouselYMargin: CGFloat = 10.0
let kAccountCarouselPeek: CGFloat = 20.0

let kAccountCarouselWidth: CGFloat = UIScreen.main.bounds.width - 2 * kAccountCarouselXMargin - kAccountCarouselPeek
let kAccountCarouselHeight: CGFloat = UIScreen.main.bounds.width / kAccountCarouselWidthHeightRatio
