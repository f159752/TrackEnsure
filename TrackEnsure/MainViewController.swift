//
//  MainViewController.swift
//  TrackEnsure
//
//  Created by Artem Shpilka on 4/8/20.
//  Copyright © 2020 Artem Shpilka. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class MainViewController: UIViewController {

    @IBOutlet weak var containerViewController: UIView!
    let network: NetworkManager = NetworkManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Заправки"
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        network.reachability.whenReachable = { reachability in
            DispatchQueue.main.async {
                self.navigationController?.navigationBar.barStyle = .black
                self.navigationController?.navigationBar.tintColor = .white
                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            }
            Storage.shared.synchronizeDatabase()
        }
        
        network.reachability.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                self.navigationController?.navigationBar.barStyle = .default
                self.navigationController?.navigationBar.tintColor = .black
                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            }
        }
        
    }
    

}

