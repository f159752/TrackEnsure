//
//  StationTableViewControllerViewModelType.swift
//  TrackEnsure
//
//  Created by Artem Shpilka on 4/8/20.
//  Copyright © 2020 Artem Shpilka. All rights reserved.
//

import UIKit

protocol StationTableViewControllerViewModelType {
    func numberOfSection() -> Int
    func numberOfRows(in section: Int) -> Int
    func cellViewModel(forIndexPath indexPath: IndexPath) -> StationTableViewCellViewModelType?
    func heightForRowAt(indexPath: IndexPath) -> CGFloat
    func setupStorage(copletion: @escaping ()->())
    func getStationBy(row: Int) -> GasStation?
}
