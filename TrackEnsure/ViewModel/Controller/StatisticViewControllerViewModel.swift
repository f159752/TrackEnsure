//
//  StatisticViewControllerViewModel.swift
//  TrackEnsure
//
//  Created by Artem Shpilka on 4/10/20.
//  Copyright © 2020 Artem Shpilka. All rights reserved.
//

import UIKit
import RealmSwift

class StatisticViewControllerViewModel: StatisticViewControllerViewModelType {
    
    let storage = Storage.shared
    
    var filteredGasStation: [GasStation] = []
//    var filteredGasStation: Results<GasStation>!
    var dataSource: [Int:String] = [:]
    
    func numberOfSection() -> Int {
        return 1
    }
    
    func numberOfRows(in section: Int) -> Int {
        return dataSource.count
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> StatisticTableViewCellViewModel? {
        guard let value = dataSource[indexPath.row] else { return nil }
        return StatisticTableViewCellViewModel(indexRow: indexPath.row, value: value)
    }
    
    func heightForRowAt(indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * 2/3
    }
    
    func filterGasStations(by address: String, completion: @escaping ()->()){
        guard address != "" else {
            dataSource = [:]
            completion()
            return
        }
        filteredGasStation = [GasStation](storage.invitedGasStations.filter("address == '\(address)'"))
//        filteredGasStation = storage.invitedGasStations.filter("address == '\(address)'")
        
        if filteredGasStation.count == 0{
            completion()
            return
        }
        
        let count = filteredGasStation.count
        var volumeFuel: Double = 0.0
        var sum: Double = 0.0
        var lastInvite: Date = "2000-01-01 00:00:00 GMT+3".getDateFrom() ?? Date()
        for item in filteredGasStation{
            guard let volume = item.count.value, let price = item.price.value else { continue }
            volumeFuel += volume.countToVolume()
            sum += volume.countToVolume() * price.priceToMoney()
            lastInvite = item.date > lastInvite ? item.date : lastInvite
        }
        sum = (sum * 100).rounded() / 100
        
        dataSource[0] = String(describing: count)
        dataSource[1] = String(describing: volumeFuel)
        dataSource[2] = String(describing: sum)
        dataSource[3] = lastInvite.getStringFrom() ?? "2000-01-01 00:00:00 GMT+3"
        
        completion()
    }
    
    
    
    
}
