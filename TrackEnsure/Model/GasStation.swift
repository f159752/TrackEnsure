//
//  GasStation.swift
//  TrackEnsure
//
//  Created by Artem Shpilka on 4/8/20.
//  Copyright © 2020 Artem Shpilka. All rights reserved.
//

import Foundation
import MapKit
import RealmSwift

class GasStation: Object {
    @objc dynamic var id = UUID().uuidString
    dynamic var idUser = RealmOptional<Int>()
    @objc dynamic var name: String?
    @objc dynamic var latitude: String?
    @objc dynamic var longitude: String?
    @objc dynamic var address: String?
    @objc dynamic var type: String?
    dynamic var count = RealmOptional<Int>()      //      3600 = 36 L
    dynamic var price = RealmOptional<Int>()      //      2745 = 27.45
    @objc dynamic var date: Date = Date()
    @objc dynamic var synchronized: Bool = true
}

struct GasStationFirebaseObject: Codable {
    var id: String
    var idUser: Int
    var name: String
    var latitude: String
    var longitude: String
    var address: String
    var type: String
    var count: Int      //      3600 = 36 L
    var price: Int      //      2745 = 27.45
    var date: String
    var synchronized: Bool
    
    func toGasStation() -> GasStation{
        let station = GasStation()
        station.id = self.id
        station.idUser.value = self.idUser
        station.name = self.name
        station.latitude = self.latitude
        station.longitude = self.longitude
        station.address = self.address
        station.type = self.type
        station.count.value = self.count
        station.price.value = self.price
        if let date = self.date.getDateFrom(){
            station.date = date
        }else{
            station.date = Date()
        }
        station.synchronized = self.synchronized
        return station
    }
}


