//
//  ViewController.swift
//  TrackEnsure
//
//  Created by Artem Shpilka on 4/8/20.
//  Copyright © 2020 Artem Shpilka. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class ViewController: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {
        self.settings.style.buttonBarBackgroundColor = .systemGray
        self.settings.style.buttonBarItemTitleColor = .white
        self.settings.style.buttonBarItemBackgroundColor = .systemGray
        
        super.viewDidLoad()
        
        buttonBarView.selectedBar.backgroundColor = .red
        buttonBarView.backgroundColor = UIColor.systemGray
        
        containerView.isScrollEnabled = false
        
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child1 = StationTableViewController(style: .plain, itemInfo: "Посещенные")
        let child2 = StatisticViewController(itemInfo: "Статистика")

        return [child1, child2]
    }
    

}
