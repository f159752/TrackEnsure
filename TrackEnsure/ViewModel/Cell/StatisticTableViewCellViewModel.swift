//
//  StatisticTableViewCellViewModel.swift
//  TrackEnsure
//
//  Created by Artem Shpilka on 4/10/20.
//  Copyright © 2020 Artem Shpilka. All rights reserved.
//

import Foundation

class StatisticTableViewCellViewModel: StatisticTableViewCellViewModelType{
    var title: String{
        switch indexRow {
        case 0:
            return "Посещения"
        case 1:
            return "Объем"
        case 2:
            return "Потрачено"
        default:
            return "Последнее посещение"
        }
    }
    
    var value: String{
        return _value
    }
    
    var indexRow: Int
    var _value: String
    
    init(indexRow: Int, value: String) {
        self.indexRow = indexRow
        self._value = value
    }
    
}
