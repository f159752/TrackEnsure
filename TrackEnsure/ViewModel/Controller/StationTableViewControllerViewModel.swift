//
//  StationTableViewControllerViewModel.swift
//  TrackEnsure
//
//  Created by Artem Shpilka on 4/8/20.
//  Copyright © 2020 Artem Shpilka. All rights reserved.
//

import UIKit

class StationTableViewControllerViewModel: StationTableViewControllerViewModelType{
    
    let storage = Storage.shared
    
    func setupStorage(copletion: @escaping ()->()){
        if storage.isFirstLaunch(){
            print("First")
            storage.loadFromFirebase {
                self.storage.reloadAddressesAllInvitedGasStation()
                copletion()
            }
        }else{
            print("Not first")
            storage.synchronizeDatabase()
            storage.reloadAddressesAllInvitedGasStation()
            copletion()
        }
    }
    
    func numberOfSection() -> Int {
        return 1
    }
    
    func numberOfRows(in section: Int) -> Int {
        return storage.invitedGasStations.count
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> StationTableViewCellViewModelType? {
        return StationTableViewCellViewModel(gasStation: storage.invitedGasStations[indexPath.row])
    }
    
    
    func heightForRowAt(indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 2
    }
    
    func getStationBy(row: Int) -> GasStation?{
        return storage.invitedGasStations[row]
    }
    
    
}
