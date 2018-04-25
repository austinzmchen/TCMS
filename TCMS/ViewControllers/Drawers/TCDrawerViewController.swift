//
//  TCDrawerViewController.swift
//  GoWWorldBosses
//
//  Created by Austin Chen on 2016-11-27.
//  Copyright © 2016 Austin Chen. All rights reserved.
//

import UIKit

protocol TCDrawerViewControllerDelegate: class {
    func didSelect(drawerItem: TCDrawerItem, atIndex index: Int)
}

struct TCDrawerItem {
    let normalImageName: String
    let selectedImageName: String
    let title: String
    let storyboardFileName: String
    let storyboardID: String
}

class TCDrawerViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView?

    @IBAction func closeButtonTapped(_ sender: Any) {
        viewDelegate?.didTriggerToggleButton()
    }
    
    @IBAction func settingsButtonTapped(_ sender: Any) {
        self.showSettingsPage(animated: true)
    }
    
    func showSettingsPage(animated: Bool) {
        let settingsNavVC = TCStoryboardFactory.settingsStoryboard.instantiateViewController(withIdentifier: "settingsNavVC")
        self.present(settingsNavVC, animated: animated, completion: nil)
    }
    
    static let drawerItems: [TCDrawerItem] = [
        TCDrawerItem(normalImageName: "icTimers",
                     selectedImageName: "icTimersOn",
                     title: "Home",
                     storyboardFileName: "Main",
                     storyboardID: "mainVC"),
        TCDrawerItem(normalImageName: "icCharacters",
                     selectedImageName: "icCharactersOn",
                     title: "Calendar",
                     storyboardFileName: "Main",
                     storyboardID: "calendarVC"),
        TCDrawerItem(normalImageName: "icCharacters",
                     selectedImageName: "icCharactersOn",
                     title: "Help",
                     storyboardFileName: "Main",
                     storyboardID: "calendarVC"),
        TCDrawerItem(normalImageName: "icCharacters",
                     selectedImageName: "icCharactersOn",
                     title: "About Us",
                     storyboardFileName: "Main",
                     storyboardID: "aboutusVC")]

    
    weak var delegate: TCDrawerViewControllerDelegate?
    weak var viewDelegate: TCDrawerMasterViewControllerDelegate?
    var selectedDrawerItem: TCDrawerItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true // use custom view to replace nav bar for style reason
        
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.selectedDrawerItem = type(of: self).drawerItems.first // select timers as default
        self.tableView?.reloadData()
    }
}

extension TCDrawerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return type(of: self).drawerItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "drawerTableCell") as! TCDrawerTableViewCell
        let item = type(of: self).drawerItems[indexPath.row]
        if item.title == selectedDrawerItem?.title {
            cell.leftImageView.image = UIImage(named: item.selectedImageName)
        } else {
            cell.leftImageView.image = UIImage(named: item.normalImageName)
        }
        cell.mainTitleLabel.text = item.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = type(of: self).drawerItems[indexPath.row]
        if item.title ~= "Help" {
            UIApplication.shared.open(URL(string: "mailto:help@mytyria.com")!, options: [:]) { (finished) in
                print("finished: \(finished)")
            }
            return
        }
        self.delegate?.didSelect(drawerItem: item, atIndex: indexPath.row)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
