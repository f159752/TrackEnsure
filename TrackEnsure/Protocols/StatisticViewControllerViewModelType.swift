//
//  StatisticViewControllerViewModelType.swift
//  TrackEnsure
//
//  Created by Artem Shpilka on 4/10/20.
//  Copyright © 2020 Artem Shpilka. All rights reserved.
//

import UIKit

protocol StatisticViewControllerViewModelType {
    func numberOfSection() -> Int
    func numberOfRows(in section: Int) -> Int
    func cellViewModel(forIndexPath indexPath: IndexPath) -> StatisticTableViewCellViewModel?
    func heightForRowAt(indexPath: IndexPath) -> CGFloat
    func filterGasStations(by address: String, completion: @escaping ()->())
}
