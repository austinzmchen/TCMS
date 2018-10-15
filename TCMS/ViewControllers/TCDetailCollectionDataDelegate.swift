//
//  TCDetailCollectionDataDelegate.swift
//  TCMS
//
//  Created by Austin Chen on 2018-10-14.
//  Copyright © 2018 Austin Chen. All rights reserved.
//

import UIKit

class TCDetailCollectionDataDelegate: NSObject {
    var vc: TCDetailViewController
    
    private let kAccountCarouselXMargin: CGFloat = 0
    private let kAccountCarouselYMargin: CGFloat = 0
    private let kAccountCarouselPeek: CGFloat = 0
    private var kAccountCarouselWidth: CGFloat {
        return vc.elasticHeaderView.eView.bounds.width
    }

    init?(fromViewController vc: UIViewController) {
        guard let v = vc as? TCDetailViewController else { return nil }
        self.vc = v
    }
}

extension TCDetailCollectionDataDelegate: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vc.event?.images.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "kDetailCollectionCell", for: indexPath) as! TCDetailTopCollectionCell
        
        if let path = vc.event?.images[indexPath.row].path {
            cell.imgView.sdSetImage(withString: path)
        }
        return cell
    }
}


extension TCDetailCollectionDataDelegate: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: kAccountCarouselWidth, height: collectionView.bounds.height)
    }
}


extension TCDetailCollectionDataDelegate: UIScrollViewDelegate {
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
