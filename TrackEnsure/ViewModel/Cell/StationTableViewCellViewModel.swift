//
//  StationTableViewCellViewModel.swift
//  TrackEnsure
//
//  Created by Artem Shpilka on 4/8/20.
//  Copyright © 2020 Artem Shpilka. All rights reserved.
//

import Foundation
import MapKit

class StationTableViewCellViewModel: StationTableViewCellViewModelType{
    var name: String{
        guard let name = gasStation.name else { return "" }
        return name
    }
    
    var location: CLLocation{
        guard let latitudeString = gasStation.latitude, let longitudeString = gasStation.longitude, let latitude = CLLocationDegrees(latitudeString), let longitude = CLLocationDegrees(longitudeString) else { return CLLocation() }
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    var type: TypeOfPetrol{
        guard let type = gasStation.type else { return TypeOfPetrol.none }
        switch type {
        case TypeOfPetrol.gasoline.rawValue, TypeOfPetrol.gasoline.translated():
            return TypeOfPetrol.gasoline
        case TypeOfPetrol.diesel.rawValue, TypeOfPetrol.diesel.translated():
            return TypeOfPetrol.diesel
        default:
            return TypeOfPetrol.none
        }
    }
    
    var count: Int{
        guard let count = gasStation.count.value else { return 0 }
        return count
    }
    
    var price: Int{
        guard let price = gasStation.price.value else { return 0 }
        return price
    }
    
    var totalSpent: Double{
        let total = count.countToVolume() * price.priceToMoney()
        return (total * 100).rounded() / 100
    }
    
    var gasStation: GasStation
    
    init(gasStation: GasStation) {
        self.gasStation = gasStation
    }
}
