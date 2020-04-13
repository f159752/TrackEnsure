//
//  StationTableViewCellViewModelType.swift
//  TrackEnsure
//
//  Created by Artem Shpilka on 4/8/20.
//  Copyright © 2020 Artem Shpilka. All rights reserved.
//

import Foundation
import MapKit

protocol StationTableViewCellViewModelType: class {
    var gasStation: GasStation { get }
    
    var name: String { get }
    var location: CLLocation { get }
    var type: TypeOfPetrol { get }
    var count: Int { get }
    var price: Int { get }
    var totalSpent: Double { get }
}
