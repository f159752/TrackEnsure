//
//  StatisticViewController.swift
//  TrackEnsure
//
//  Created by Artem Shpilka on 4/10/20.
//  Copyright © 2020 Artem Shpilka. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SnapKit
import DropDown

class StatisticViewController: UIViewController, IndicatorInfoProvider {
    
    var itemInfo = IndicatorInfo(title: "View")
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    var viewModel: StatisticViewControllerViewModelType?
    
    init(itemInfo: IndicatorInfo){
        super.init(nibName: nil, bundle: nil)
        self.itemInfo = itemInfo
        
        viewModel = StatisticViewControllerViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let reuseIdentifier = "statisticCell"
    
    lazy var searchTextField = UITextField()
    var searchDropDown = DropDown()
    lazy var tableView = UITableView()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        searchTextField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(StatisticTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        searchDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.searchTextField.text = item
            guard let viewModel = self.viewModel else { return }
            viewModel.filterGasStations(by: item) {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchDropDown.dataSource = Storage.shared.getAddressesAllInvitedGasStation()
        searchTextField.text = ""
        guard let viewModel = self.viewModel, let text = searchTextField.text else { return }
        viewModel.filterGasStations(by: text) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }


    
    func setupUI(){
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        view.addSubview(searchTextField)
        searchDropDown.anchorView = searchTextField
        view.addSubview(tableView)
        
        searchTextField.borderStyle = .roundedRect
        searchTextField.layer.shadowColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1).cgColor
        searchTextField.layer.shadowOpacity = 1
        searchTextField.layer.shadowRadius = 11
        searchTextField.placeholder = "Выбрать адрес"

        searchTextField.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).inset(8)
            make.left.equalTo(view.snp.left).inset(8)
            make.right.equalTo(view.snp.right).inset(8)
            make.height.equalTo(41)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(searchTextField.snp.bottom).offset(16)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottom)
        }
    }

}


extension StatisticViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        searchDropDown.show()
    }
}


extension StatisticViewController: UITableViewDelegate{
    
}


extension StatisticViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? StatisticTableViewCell
        
        guard let tableViewCell = cell, let viewModel = viewModel else { return UITableViewCell() }
        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
        tableViewCell.viewModel = cellViewModel
        
        return tableViewCell
    }
    
    
}
