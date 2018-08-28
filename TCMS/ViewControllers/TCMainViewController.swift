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
    
    @IBOutlet weak var leftBarButton: UIButton!
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
    
    private var remote = TCEventRemote(remoteSession: nil)
    private var events: [TCJsonEvent] = []
    
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
        
        tableView.register(UINib.init(nibName: "STTableV2Cell", bundle: nil), forCellReuseIdentifier: "kHomeTableCell1")
        tableView.register(UINib.init(nibName: "STTableHeroCell", bundle: nil), forCellReuseIdentifier: "kHomeTableHeroCell")
        
        remote.fetchCollections(byPath: "") { (result) in
            if case .success(let value) = result {
                DispatchQueue.main.async {
                    self.events = value.data
                    self.tableView.reloadData()
                }
            }
        }
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
        return events.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 {
            return 180
        }
        return 107
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "kHomeTableHeroCell", for: indexPath) as! STTableHeroCell
            cell.parallaxView.backgroundImageView.image = UIImage.init(named: "parallaxImage")
            cell.parallaxView.backgroundImageView.contentMode = .scaleAspectFill
            cell.parallaxView.parallaxScrollFactor = 0.13
            return cell
        }
        let event = events[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "kHomeTableCell1", for: indexPath) as! STTableV2Cell
        cell.imgView.sdSetImage(withString: event.images.first?.path)
        cell.titleLabel.text = event.title
        
        cell.topBorderView.isHidden = indexPath.row == 2 + 1
        cell.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0.0
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            cell.alpha = 1.0
        }, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // print(scrollView.contentOffset.y)
        
        var f = headerView1.frame
        f.origin.y = scrollView.contentOffset.y // make header view stay at top flushed
        f.size.height = max(-scrollView.contentOffset.y-kHeight2, kMinHeight)
        headerView1.frame = f
//        print(f.size.height)
        leftBarButton.alpha = (f.size.height - 20) / 44
        
        if -scrollView.contentOffset.y-kHeight2 < kMinHeight {
            headerView2.clipsToBounds = true
            /*
            // print(hv2Title.frame.minY)
            headerView.constraints.first{$0.identifier == "kTitleCstTop"}?.constant =
                min(-hv2Title.frame.minY,
                    (headerView.bounds.height + hv1Title.bounds.height) / 2.0 ) // + because kTitleCstTop is relative from the label top to superview bottom

            blurView.alpha = headerView.constraints.first{$0.identifier == "kTitleCstTop"}!.constant /
                ((headerView.bounds.height + hv1Title.bounds.height) / 2.0)
             */
        }
        else if -scrollView.contentOffset.y-kHeight2 >= kMinHeight,
            kHeight >= -scrollView.contentOffset.y-kHeight2
        {
            let scale:CGFloat = (100 - (kHeight2+kHeight + scrollView.contentOffset.y)) / 100
            // profileView.transform = CGAffineTransform(scaleX: scale, y: scale)
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
        
        // parallax
        tableView.visibleCells.forEach { cell in
            guard let c = cell as? STTableHeroCell
                else { return }
            let rect = c.parallaxView.convert(c.parallaxView.bounds, to: self.view)
            c.parallaxView.adjustParallax(by: rect, onVisibleBounds: self.view.bounds)
        }
    }
}

private let kHeight: CGFloat = 44
private let kMinHeight: CGFloat = 20

private let kHeight2: CGFloat = 280
private let kMinHeight2: CGFloat = 30
