//
//  ViewController.swift
//  TCMS
//
//  Created by Austin Chen on 2018-01-31.
//  Copyright © 2018 Austin Chen. All rights reserved.
//

import UIKit
import ACKit

class TCMainViewController: UIViewController, TCDrawerItemViewControllerType {
    
    @IBAction func leftBarButtonTapped(_ sender: Any) {
        viewDelegate?.didTriggerToggleButton()
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    // header view 1
    @IBOutlet var headerView1: UIView!
    
    // header view 2
    @IBOutlet var headerView2: UIView!
    @IBOutlet weak var collectionView1: UICollectionView!
    @IBOutlet var pageControlCell: UITableViewCell!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var viewDelegate: TCDrawerMasterViewControllerDelegate?
    
//    var observerTokenBag = ACNoteObserverTokenBag()
    private lazy var collectionDataDelegate: TCMainCollectionDataDelegate? = {
        return TCMainCollectionDataDelegate(fromViewController: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        collectionView1.delegate = collectionDataDelegate
        collectionView1.dataSource = collectionDataDelegate
        collectionView1.decelerationRate = UIScrollViewDecelerationRateFast // control speed for
        
        // collectionView2.delegate = self
        // collectionView2.dataSource = self
        
        pageControl.numberOfPages = 3
        
        // elastic
        var f = headerView1.frame
        f.origin = CGPoint(x: 0, y: -(kHeight + kHeight2))
        f.size = CGSize(width: view.bounds.width, height: kHeight)
        headerView1.frame = f
        tableView.addSubview(headerView1)
        
        var f2 = headerView2.frame
        f2.origin = CGPoint(x: 0, y: -kHeight2)
        f2.size = CGSize(width: view.bounds.width, height: kHeight2)
        headerView2.frame = f2
        tableView.addSubview(headerView2)
        
        // set contentInset top, makes contentOffset y to start -kHeight
        tableView.contentInset = UIEdgeInsets(top: kHeight + kHeight2, left: 0, bottom: 0, right: 0)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        var f = headerView1.frame
        f.size.width = view.bounds.width
        headerView1.frame = f
        
        f = headerView2.frame
        f.size.width = view.bounds.width
        headerView2.frame = f
    }
}

extension TCMainViewController: UITableViewDelegate, UITableViewDataSource {
    
    private struct TableCellRowInfo {
        var height: CGFloat
        var cell: UITableViewCell?
    }
    
    private var rowInfos: [TableCellRowInfo] {
        return [
//            TableCellRowInfo(height: 250, cell: cell1),
            TableCellRowInfo(height: 37.0, cell: pageControlCell),
//            TableCellRowInfo(height: 0.0, cell: cell2)
        ]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "kTableCell", for: indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // print(scrollView.contentOffset.y)
        
        var f = headerView1.frame
        f.origin.y = scrollView.contentOffset.y // make header view stay at top flushed
        f.size.height = max(-scrollView.contentOffset.y-kHeight2, kMinHeight)
        headerView1.frame = f
        
        if -scrollView.contentOffset.y-kHeight2 < kMinHeight {
            headerView2.clipsToBounds = true
            
//
//            // print(hv2Title.frame.minY)
//            headerView.constraints.first{$0.identifier == "kTitleCstTop"}?.constant =
//                min(-hv2Title.frame.minY,
//                    (headerView.bounds.height + hv1Title.bounds.height) / 2.0 ) // + because kTitleCstTop is relative from the label top to superview bottom
//
//            blurView.alpha = headerView.constraints.first{$0.identifier == "kTitleCstTop"}!.constant /
//                ((headerView.bounds.height + hv1Title.bounds.height) / 2.0)
        }
        else if -scrollView.contentOffset.y-kHeight2 >= kMinHeight,
            kHeight >= -scrollView.contentOffset.y-kHeight2
        {
            let scale:CGFloat = (100 - (kHeight2+kHeight + scrollView.contentOffset.y)) / 100
//            profileView.transform = CGAffineTransform(scaleX: scale, y: scale)
            headerView2.clipsToBounds = false
        } else {
            
        }
        
        var f2 = headerView2.frame
        f2.origin.y = scrollView.contentOffset.y + headerView1.frame.height // make header view stay at top flushed
        if -scrollView.contentOffset.y-kHeight2 <= kMinHeight {
            f2.size.height = max(-scrollView.contentOffset.y - kMinHeight, kMinHeight2)
        } else {
            f2.size.height = kHeight2
        }
        headerView2.frame = f2
    }
}

private let kHeight: CGFloat = 64
private let kMinHeight: CGFloat = 40

private let kHeight2: CGFloat = 270
private let kMinHeight2: CGFloat = 20
