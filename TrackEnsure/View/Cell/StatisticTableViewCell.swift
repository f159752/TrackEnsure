//
//  StatisticTableViewCell.swift
//  TrackEnsure
//
//  Created by Artem Shpilka on 4/10/20.
//  Copyright © 2020 Artem Shpilka. All rights reserved.
//

import UIKit

class StatisticTableViewCell: UITableViewCell {

    weak var viewModel: StatisticTableViewCellViewModelType?{
        willSet(viewModel){
            guard let viewModel = viewModel else { return }
            textLabel?.text = viewModel.title
            detailTextLabel?.text = viewModel.value
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
