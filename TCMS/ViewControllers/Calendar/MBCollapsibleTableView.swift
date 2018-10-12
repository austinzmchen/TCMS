//
//  MBCollapsibleTableView.swift
//  MBNA
//
//  Created by Austin Chen on 2018-01-24.
//  Copyright © 2018 Austin Chen. All rights reserved.
//

import UIKit
import CollapsibleTableSectionViewController

class MBCollapsibleTableView: CollapsibleTableView, CollapsibleTableViewHeaderDelegate {
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        dataDelegate = MBCollapsibleTableViewDataDelegate(fromTableView: self)
        delegate = dataDelegate
        dataSource = dataDelegate
        
        separatorStyle = .none
        register(UINib(nibName: "MBCollapsibleTableViewFooter", bundle: nil), forHeaderFooterViewReuseIdentifier: "kMBCollapsibleTableViewFooter")
        register(UINib(nibName: "MBCollapsibleTableViewHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "kMBCollapsibleTableViewHeader")
        register(UINib(nibName: "MBMenuTableCell", bundle: nil), forCellReuseIdentifier: "kMBMenuTableCell")
    }
    
    override func toggleSection(_ section: Int) {
        clpDelegate?.collapsibleTableView(self, didSelectSectionHeaderAt: section)
        
        guard let sectionInfo = clpDelegate?.collapsibleTableView(self, sectionInfoAt: section)
            else { return }
        guard sectionInfo.items.count > 0 else { return } // not do anything with incollapsible ones
        
        let sectionsNeedReload = getSectionsNeedReload(section)
        reloadSections(IndexSet(sectionsNeedReload), with: .automatic)
    }
}
