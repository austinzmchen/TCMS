//
//  MBCollapsibleTableViewDataDelegate.swift
//  MBNA
//
//  Created by Austin Chen on 2018-01-24.
//  Copyright © 2018 Austin Chen. All rights reserved.
//

import UIKit
import CollapsibleTableSectionViewController

class MBCollapsibleTableViewDataDelegate: CollapsibleTableViewDataDelegate {
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "kMBCollapsibleTableViewHeader") as! MBCollapsibleTableViewHeader
        guard let sectionInfo = tView.clpDelegate?.collapsibleTableView(tableView, sectionInfoAt: section)
            else { return header }
        
        header.titleLabel.text = sectionInfo.name
        header.separatorStyle = .none
        
        // collapse status
        if sectionInfo.items.count == 0 {
            header.collapseStatus = .incollapsible
        } else {
            if tView.isSectionCollapsed(section) {
                header.collapseStatus = .collapsed
            } else {
                header.collapseStatus = .expanded
            }
        }
        
        header.section = section
        header.delegate = (tView as? CollapsibleTableViewHeaderDelegate)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let reusableFooter = tableView.dequeueReusableHeaderFooterView(withIdentifier: "kMBCollapsibleTableViewFooter") as! MBCollapsibleTableViewFooter
        return reusableFooter
    }
    
}
