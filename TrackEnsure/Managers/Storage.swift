//
//  Storage.swift
//  TrackEnsure
//
//  Created by Artem Shpilka on 4/8/20.
//  Copyright © 2020 Artem Shpilka. All rights reserved.
//

import Foundation
import MapKit
import RealmSwift


class Storage{
    static let shared = Storage()
    
    var namesOfGasStations: [String] = ["Okko", "Shell", "WOG", "RLC"]
    var invitedGasStations: Results<GasStation>!
    var setAddresses: Set<String> = Set<String>()
    var addressesOfStation: [String]{
        return [String](setAddresses)
    }
    
    private init(){
        guard let realm = try? Realm() else { return }
        invitedGasStations = realm.objects(GasStation.self).sorted(byKeyPath: "date", ascending: false)
        
        FirebaseManager.shared.getNamesOfGasStations { (names) in
            self.namesOfGasStations = names
        }
    }


    
    
    
    func synchronizeDatabase(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        for item in invitedGasStations{
            if item.synchronized != true{
                FirebaseManager.shared.changeGasStation(station: item)
            }
        }
        
        let idsMustToSave = Set(invitedGasStations.map({ $0.id }))
        var idsFromRemote = Set<String>()
        FirebaseManager.shared.getAllGasStation { (stations) in
            idsFromRemote = Set(stations.map({ $0.id }))
            
            let toDelete = idsFromRemote.subtracting(idsMustToSave)
            let toAdd = idsMustToSave.subtracting(idsFromRemote)
            
            _ = toDelete.map( { FirebaseManager.shared.removeGasStation(id: $0) } )
            for item in toAdd{
                let stationOpt = self.invitedGasStations.first { (station) -> Bool in
                    return station.id == item
                }
                guard let station = stationOpt else { continue }
                FirebaseManager.shared.addNewGasStation(station: station)
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    func loadFromFirebase(completion: @escaping () -> ()){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        FirebaseManager.shared.getAllGasStation { (stations) in
            for (index, item) in stations.enumerated(){
                self.addNewGasStation(item) {
                    if index == stations.count - 1{
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        completion()
                    }
                }
            }
        }
    }
    
    
    func isFirstLaunch() -> Bool{
        guard let realm = try? Realm() else { return true }
        let settings = realm.objects(SettingsStorage.self)
        if settings.count == 0{
            let settings = SettingsStorage()
            settings.isFirstStart = false
            try! realm.write{
                realm.add(settings)
            }
            return true
        }else{
            for item in settings{
                return item.isFirstStart
            }
        }
        return true
    }
    
    
    func addNewGasStation(_ station: GasStation, completion: @escaping () -> ()){
        guard let realm = try? Realm() else { return }
        do{
            try realm.write{
                realm.add(station)
                if let address = station.address{
                    self.setAddresses.insert(address)
                }
            }
        }catch let error{
            print(error.localizedDescription)
        }
        completion()
    }
    
    func deleteGasStation(_ station: GasStation, completion: @escaping () -> ()){
        guard let realm = try? Realm() else { return }
        do {
            try realm.write{
                realm.delete(station)
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        completion()
    }
    
    func editGasStation(_ newStation: GasStation, row: Int, completion: @escaping () -> ()){
        guard let realm = try? Realm() else { completion(); return }
        let stationInDB = invitedGasStations[row]
        do {
            try realm.write{
                stationInDB.name = newStation.name
                stationInDB.type = newStation.type
                stationInDB.count.value = newStation.count.value
                stationInDB.price.value = newStation.price.value
                stationInDB.latitude = newStation.latitude
                stationInDB.longitude = newStation.longitude
                stationInDB.address = newStation.address
                stationInDB.synchronized = false
                completion()
            }
        } catch let error{
            print(error.localizedDescription)
            completion()
        }
        
    }
    
    
    func getAddressesAllInvitedGasStation() -> [String]{
        return addressesOfStation
    }
    
    func reloadAddressesAllInvitedGasStation(){
        for station in invitedGasStations{
            guard let address = station.address else { continue }
            setAddresses.insert(address)
        }
    }
    
    
    func getAddressString(location: CLLocation, completion: @escaping (String?)->()){
        if ReachabilityInternet.isConnectedToNetwork(){
            let ceo: CLGeocoder = CLGeocoder()
            ceo.reverseGeocodeLocation(location, completionHandler:
                {(placemarks, error) in
                    if (error != nil)
                    {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                        completion(nil)
                    }
                    guard let placemarks = placemarks else { completion(nil); return }
                    let pm = placemarks as [CLPlacemark]
                    
                    if pm.count > 0 {
                        let pm = placemarks[0]
                        
                        var addressString : String = ""
                        
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.subThoroughfare != nil {
                            addressString = addressString + pm.subThoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! + ", "
                        }
                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                        }
                        completion(addressString)
                    }
            })
        }else{
            completion(nil)
        }
    }
    
    
//    func getAddressString(location: CLLocation, completion: @escaping (String?)->()){
//            let ceo: CLGeocoder = CLGeocoder()
//            ceo.reverseGeocodeLocation(location, completionHandler:
//                {(placemarks, error) in
//                    if (error != nil)
//                    {
//                        print("reverse geodcode fail: \(error!.localizedDescription)")
//                        completion(nil)
//                    }
//                    let pm = placemarks! as [CLPlacemark]
//
//                    if pm.count > 0 {
//                        let pm = placemarks![0]
//
//                        var addressString : String = ""
//
//                        if pm.thoroughfare != nil {
//                            addressString = addressString + pm.thoroughfare! + ", "
//                        }
//                        if pm.subThoroughfare != nil {
//                            addressString = addressString + pm.subThoroughfare! + ", "
//                        }
//                        if pm.locality != nil {
//                            addressString = addressString + pm.locality! + ", "
//                        }
//                        if pm.country != nil {
//                            addressString = addressString + pm.country! + ", "
//                        }
//                        if pm.postalCode != nil {
//                            addressString = addressString + pm.postalCode! + " "
//                        }
//
//
//                        //                    print(addressString)
//                        completion(addressString)
//                    }
//            })
//
//        }

    
}


class SettingsStorage: Object{
    @objc dynamic var isFirstStart: Bool = true
}
