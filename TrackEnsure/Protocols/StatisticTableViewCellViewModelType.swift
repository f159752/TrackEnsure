//
//  StatisticTableViewCellViewModelType.swift
//  TrackEnsure
//
//  Created by Artem Shpilka on 4/10/20.
//  Copyright © 2020 Artem Shpilka. All rights reserved.
//

import Foundation

protocol StatisticTableViewCellViewModelType: class {
    var title: String { get }
    var value: String { get }
}
