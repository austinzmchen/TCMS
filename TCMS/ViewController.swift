//
//  ViewController.swift
//  TCMS
//
//  Created by Austin Chen on 2018-01-31.
//  Copyright © 2018 Austin Chen. All rights reserved.
//

import UIKit
import ACKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var cell1: UITableViewCell!
    @IBOutlet weak var collectionView1: UICollectionView!
    
    @IBOutlet weak var cell2: UITableViewCell!
    @IBOutlet weak var collectionView2: UICollectionView!
    
    @IBOutlet var pageControlCell: UITableViewCell!
    @IBOutlet weak var pageControl: UIPageControl!
    
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    private struct TableCellRowInfo {
        var height: CGFloat
        var cell: UITableViewCell?
    }
    
    private var rowInfos: [TableCellRowInfo] {
        return [
            TableCellRowInfo(height: 250, cell: cell1),
            TableCellRowInfo(height: 37.0, cell: pageControlCell),
            TableCellRowInfo(height: 0.0, cell: cell2)
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
}
