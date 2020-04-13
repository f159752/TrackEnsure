//
//  StationTableViewController.swift
//  TrackEnsure
//
//  Created by Artem Shpilka on 4/8/20.
//  Copyright © 2020 Artem Shpilka. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class StationTableViewController: UITableViewController, IndicatorInfoProvider {

    let reuseIdentifier = "stationCell"
    var itemInfo = IndicatorInfo(title: "View")
    
    var viewModel: StationTableViewControllerViewModelType?

    init(style: UITableView.Style, itemInfo: IndicatorInfo) {
        super.init(style: style)
        
        self.itemInfo = itemInfo
        viewModel = StationTableViewControllerViewModel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(StationTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        guard let viewModel = viewModel else { return }
        viewModel.setupStorage {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.numberOfSection()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.numberOfRows(in: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? StationTableViewCell
        
        guard let tableViewCell = cell, let viewModel = viewModel else { return UITableViewCell() }
        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
        tableViewCell.viewModel = cellViewModel
        
        return tableViewCell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? StationTableViewCell
        
        guard let tableViewCell = cell else { return }
        tableViewCell.showBlurView()
    }
    
    // MARK: - UITAbleViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.heightForRowAt(indexPath: indexPath)
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
////        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? StationTableViewCell else { return }
////        guard let viewModel = cell.viewModel as? StationTableViewCellViewModel else { return }
//
//        print(indexPath.row)
//
//        let station = Storage.shared.invitedGasStations[indexPath.row]
//
//        Storage.shared.deleteGasStation(station) {
//            self.tableView.reloadData()
//        }
//
//    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editButton = UITableViewRowAction(style: .normal, title: "Изменить") { (rowAction, indexPath) in

            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "newEditStationSID")
            guard let newCreateVC = vc as? NewEditStationViewController else { return }
            newCreateVC.title = "Редактировать"
            newCreateVC.isCreateNewGasStation = false
            newCreateVC.editIndex = indexPath.row
 
            self.navigationController?.pushViewController(newCreateVC, animated: true)
        }
        let deleteButton = UITableViewRowAction(style: .destructive, title: "Удалить") { (rowAction, indexPath) in
            
            print(indexPath.row)
            let station = Storage.shared.invitedGasStations[indexPath.row]
            Storage.shared.deleteGasStation(station) {
                self.tableView.reloadData()
            }
        }
        
        return [editButton, deleteButton]
    }

    // MARK: - IndicatorInfoProvider

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }

}
