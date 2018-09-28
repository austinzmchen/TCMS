//
//  ViewController.swift
//  TCMS
//
//  Created by Austin Chen on 2018-01-31.
//  Copyright © 2018 Austin Chen. All rights reserved.
//

import UIKit
import ACKit
import SDWebImage

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
    
    // pt stuff
    var currentCell: ParallaxCell?
    var duration: Double = 0.8
    var currentTextLabel: MovingLabel?
    
    private lazy var collectionDataDelegate: TCMainCollectionDataDelegate? = {
        return TCMainCollectionDataDelegate(fromViewController: self)
    }()
    
    private var remote = TCEventRemote(remoteSession: nil)
    private var events: [TCJsonEvent] = []
    
    let items = [("1", "River cruise"), ("2", "North Island"), ("3", "Mountain trail"), ("4", "Southern Coast"), ("5", "Fishing place")] // image
    
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
    
    // pt stuff
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        moveCellsBackIfNeed(duration) {
            self.tableView.reloadData()
        }
        closeCurrentCellIfNeed(duration)
        moveDownCurrentLabelIfNeed()
    }
}

extension TCMainViewController: UITableViewDelegate, UITableViewDataSource {
    
    private struct TableCellRowInfo {
        var height: CGFloat
        var cell: UITableViewCell?
    }
    
    private var rowInfos: [TableCellRowInfo] {
        return [
            // TableCellRowInfo(height: 250, cell: cell1),
            TableCellRowInfo(height: 37.0, cell: pageControlCell),
            // TableCellRowInfo(height: 0.0, cell: cell2)
        ]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let event = events[indexPath.row]
        if event.isFeatured {
            // return 180
            return 240
        }
        return 107
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = events[indexPath.row]
        if event.isFeatured {
            let cell: ParallaxCell = tableView.getReusableCellWithIdentifier(indexPath: indexPath)
            if let p = event.images.first?.path {
                SDWebImageManager.shared().loadImage(with: URL.init(string: p), options: [], progress: nil) { (image, _, _, _, _, _) in
                    guard let image = image else {return}
                    cell.setImage(image, title: event.title ?? "")
                }
            }
            return cell
        }

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
    
    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let currentCell = tableView.cellForRow(at: indexPath) as? ParallaxCell else {
            return indexPath
        }
        
        self.currentCell = currentCell
        return indexPath
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = events[indexPath.row]
        if event.isFeatured {
            let detaleViewController = TCStoryboardFactory.ptStuffStoryboard
                .instantiateInitialViewController() as! DemoDetailViewController
            pushViewController(detaleViewController)
        } else {
            performSegue(withIdentifier: "kNormalCellPush", sender: nil)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // print(scrollView.contentOffset.y)

        var f = headerView1.frame
        f.origin.y = scrollView.contentOffset.y // make header view stay at top flushed
        f.size.height = max(-scrollView.contentOffset.y-kHeight2, kMinHeight)
        headerView1.frame = f
        // print(f.size.height)
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

extension TCMainViewController {
    
    /**
     Pushes a view controller onto the receiver’s stack and updates the display whith custom animation.
     
     - parameter viewController: The view controller to push onto the stack.
     */
    public func pushViewController(_ viewController: PTDetailViewController) {
        
        guard let currentCell = currentCell,
            let navigationController = self.navigationController else {
                fatalError("current cell is empty or add navigationController")
        }
        
        if let currentIndex = tableView.indexPath(for: currentCell) {
            let nextIndex = IndexPath(row: (currentIndex as NSIndexPath).row + 1, section: (currentIndex as NSIndexPath).section)
            if case let nextCell as ParallaxCell = tableView.cellForRow(at: nextIndex) {
                nextCell.showTopSeparator()
                nextCell.superview?.bringSubview(toFront: nextCell)
            }
        }
        
        currentTextLabel = createTitleLable(currentCell)
        currentTextLabel?.move(duration, direction: .up, completion: nil)
        
        currentCell.openCell(tableView, duration: duration)
        moveCells(tableView, currentCell: currentCell, duration: duration)
        if let bgImage = currentCell.bgImage?.image {
            viewController.bgImage = bgImage
        }
        if let text = currentCell.parallaxTitle?.text {
            viewController.titleText = text
        }
        delay(duration) {
            navigationController.pushViewController(viewController, animated: false)
        }
    }
}

extension TCMainViewController {
    
    fileprivate func createTitleLable(_ cell: ParallaxCell) -> MovingLabel {
        
        let yPosition = cell.frame.origin.y + cell.frame.size.height / 2.0 - 22 - tableView.contentOffset.y
        let label = MovingLabel(frame: CGRect(x: 0, y: yPosition, width: UIScreen.main.bounds.size.width, height: 44))
        label.textAlignment = .center
        label.backgroundColor = .clear
        if let font = cell.parallaxTitle?.font,
            let text = cell.parallaxTitle?.text,
            let textColor = cell.parallaxTitle?.textColor {
            label.font = font
            label.text = text
            label.textColor = textColor
        }
        
        navigationController?.view.addSubview(label)
        return label
    }
    
    fileprivate func createSeparator(_ color: UIColor?, height: CGFloat, cell: UITableViewCell) -> MovingView {
        
        let yPosition = cell.frame.origin.y + cell.frame.size.height - tableView.contentOffset.y
        let separator = MovingView(frame: CGRect(x: 0.0, y: yPosition, width: tableView.bounds.size.width, height: height))
        if let color = color {
            separator.backgroundColor = color
        }
        separator.translatesAutoresizingMaskIntoConstraints = false
        navigationController?.view.addSubview(separator)
        return separator
    }
}

// MARK: helpers

extension TCMainViewController {
    
    fileprivate func parallaxOffsetDidChange(_: CGFloat) {
        
        _ = tableView.visibleCells
            .filter { $0 != currentCell }
            .forEach { if case let cell as ParallaxCell = $0 { cell.parallaxOffset(tableView) } }
    }
    
    fileprivate func moveCellsBackIfNeed(_ duration: Double, completion: @escaping () -> Void) {
        
        guard let currentCell = self.currentCell,
            let currentIndex = tableView.indexPath(for: currentCell) else {
                return
        }
        
        for case let cell as ParallaxCell in tableView.visibleCells where cell != currentCell {
            
            if cell.isMovedHidden == false { continue }
            
            if let index = tableView.indexPath(for: cell) {
                let direction = (index as NSIndexPath).row < (currentIndex as NSIndexPath).row ? ParallaxCell.Direction.up : ParallaxCell.Direction.down
                cell.animationMoveCell(direction, duration: duration, tableView: tableView, selectedIndexPaht: currentIndex, close: true)
                cell.isMovedHidden = false
            }
        }
        delay(duration, closure: completion)
    }
    
    fileprivate func closeCurrentCellIfNeed(_ duration: Double) {
        
        guard let currentCell = self.currentCell else {
            return
        }
        
        currentCell.closeCell(duration, tableView: tableView) { () -> Void in
            self.currentCell = nil
        }
    }
    
    fileprivate func moveDownCurrentLabelIfNeed() {
        
        guard let currentTextLabel = self.currentTextLabel else {
            return
        }
        currentTextLabel.move(duration, direction: .down) { _ in
            currentTextLabel.removeFromSuperview()
            self.currentTextLabel = nil
        }
    }
    
    //  animtaions
    fileprivate func moveCells(_ tableView: UITableView, currentCell: ParallaxCell, duration: Double) {
        guard let currentIndex = tableView.indexPath(for: currentCell) else {
            return
        }
        
        for case let cell as ParallaxCell in tableView.visibleCells where cell != currentCell {
            cell.isMovedHidden = true
            if let row = (tableView.indexPath(for: cell) as NSIndexPath?)?.row {
                let direction = row < (currentIndex as NSIndexPath).row ? ParallaxCell.Direction.down : ParallaxCell.Direction.up
                cell.animationMoveCell(direction, duration: duration, tableView: tableView, selectedIndexPaht: currentIndex, close: false)
            }
        }
    }
}

private let kHeight: CGFloat = 44
private let kMinHeight: CGFloat = 20

private let kHeight2: CGFloat = 280
private let kMinHeight2: CGFloat = 30
