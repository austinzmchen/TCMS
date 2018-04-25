//
//  TCDrawerMasterViewController.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-11-27.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import UIKit
import KYDrawerController

protocol TCDrawerItemViewControllerType: class {
    var viewDelegate: TCDrawerMasterViewControllerDelegate? {get set}
}

protocol TCDrawerMasterViewControllerDelegate: class {
    func didTriggerToggleButton()
    func drawerItemVCShouldChange()
}

enum DrawerOpeningState {
    case closed
    case open
}

class TCDrawerMasterViewController: UINavigationController {
    
    fileprivate var selectedDrawerItem: TCDrawerItem?
    
    let drawerVC = TCStoryboardFactory.drawerStoryboard.instantiateViewController(withIdentifier: "drawerVC") as! TCDrawerViewController
    
    fileprivate var drawerOpeningState: DrawerOpeningState = .closed
    
    func setDrawerOpeningState(_ state: DrawerOpeningState, animated: Bool = true,
                               completion: ((_ stateChange: Bool) -> ())? = nil)
    {
        guard state != self.drawerOpeningState else {
            if let c = completion { c(false) }
            return
        }
        
        switch state {
        case .open:
            drawerVC.modalTransitionStyle = .crossDissolve
            drawerVC.modalPresentationStyle = .overCurrentContext
            self.present(drawerVC, animated: animated, completion: {
                if let c = completion { c(true) }
            }) // if using animated true, there will be a glitch where two phase, first phase fading in, second phase blurring
        case .closed:
            if animated {
                drawerVC.dismiss(animated: animated, completion: {
                    if let c = completion { c(true) }
                })
            } else {
                if let c = completion { c(true) }
            }
            break
        }
        self.drawerOpeningState = state
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        drawerVC.delegate = self
        drawerVC.viewDelegate = self
        
        // set up main
        let mainVC = TCStoryboardFactory.mainStoryboard.instantiateViewController(withIdentifier: "mainVC") as! TCMainViewController
//        let timerVC = timerNavVC.viewControllers.first as! TCMainViewController
        mainVC.viewDelegate = self
        
        self.viewControllers = [mainVC]
    }
    
    func presentDrawerItemViewController(drawerItem: TCDrawerItem) {
        let vc = TCStoryboardFactory.storyboard(byFileName: drawerItem.storyboardFileName)?.instantiateViewController(withIdentifier: drawerItem.storyboardID)
      
        if let drawerItemVC = vc as? TCDrawerItemViewControllerType {
            drawerItemVC.viewDelegate = self
            self.viewControllers = [vc!]
        }
    }
}

extension TCDrawerMasterViewController: TCDrawerViewControllerDelegate {
    
    func didSelect(drawerItem: TCDrawerItem, atIndex index: Int) {
        selectedDrawerItem = drawerItem
        
        // set drawer selected state
        // let drawerVC = (self.drawerViewController as! UINavigationController).viewControllers.first as! WBDrawerViewController
        drawerVC.selectedDrawerItem = self.selectedDrawerItem
        drawerVC.tableView?.reloadData()
        
        presentDrawerItemViewController(drawerItem: drawerItem)
        setDrawerOpeningState(.closed)
    }
}

extension TCDrawerMasterViewController: TCDrawerMasterViewControllerDelegate {
    
    func didTriggerToggleButton() {
        switch drawerOpeningState { // current state
        case .closed:
            self.setDrawerOpeningState(.open)
        case .open:
            self.setDrawerOpeningState(.closed)
        }
    }
    
    func drawerItemVCShouldChange() {
        guard let drawerItem = selectedDrawerItem else {
            return
        }
        
        self.presentDrawerItemViewController(drawerItem: drawerItem)
    }
}
