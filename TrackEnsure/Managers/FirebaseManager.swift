//
//  FirebaseManager.swift
//  TrackEnsure
//
//  Created by Artem Shpilka on 4/11/20.
//  Copyright © 2020 Artem Shpilka. All rights reserved.
//

import Foundation
import MapKit
import FirebaseDatabase

class FirebaseManager{
    static let shared = FirebaseManager()
    var ref = Database.database().reference()
    
    private init(){
        getAllGasStation { (stations) in
            print(stations)
        }
    }
    
    func getAllGasStation(completion: @escaping ([GasStation])->()){
        var stations: [GasStation] = []
        
        ref.child("gasStations").observeSingleEvent(of: .value) { (snapshot) in
            guard snapshot.exists(),
                let value = snapshot.value as? [String: Any],
                let data = value.jsonData
                else{
                    completion([])
                    return
            }
            
            do{
                let itemDictionary = try JSONDecoder().decode([String: GasStationFirebaseObject].self, from: data)
                for item in itemDictionary{
                    let firebaseStations = item.value
                    if firebaseStations.idUser == User.shared.idDriver{
                        stations.append(firebaseStations.toGasStation())
                    }
                }
            }catch let error{
                print(error.localizedDescription)
            }
            completion(stations)
        }
    }
    
    func getNamesOfGasStations(completion: @escaping ([String])->()){
        var namesOfGasStations: [String] = []
        ref.child("nameOfGasStation").observeSingleEvent(of: .value) { (snapshot) in
            guard snapshot.exists() else { completion([]); return }
            for child in snapshot.children{
                let item = child as! DataSnapshot
                guard let value = item.value, let name = value as? String else { continue }
                namesOfGasStations.append(name)
            }
            completion(namesOfGasStations)
        }
    }
    
    func addNewGasStation(station: GasStation){
        guard let name = station.name,
            let latitude = station.latitude,
            let longitude = station.longitude,
            let type = station.type,
            let count = station.count.value,
            let price = station.price.value,
            count != 0,
            price != 0,
            let date = station.date.getStringFrom(),
            let idUser = station.idUser.value
        else {
            return
        }
        
        var stationDictionary: [String : Any] = [
            "id": station.id,
            "name": name,
            "latitude": latitude,
            "longitude": longitude,
            "type": type,
            "count": count,
            "price": price,
            "date": date,
            "idUser": idUser,
            "synchronized": true
        ]

        if let address = station.address{
            stationDictionary["address"] = address
            formedAndSend(stationDictionary: stationDictionary)
        }else{
            let location = CLLocation(latitude: CLLocationDegrees((latitude as NSString).doubleValue), longitude: CLLocationDegrees((longitude as NSString).doubleValue))
            if ReachabilityInternet.isConnectedToNetwork(){
                Storage.shared.getAddressString(location: location) { (address) in
                    guard let address = address else { return }
                    stationDictionary["address"] = address
                    self.formedAndSend(stationDictionary: stationDictionary)
                }
            }else{
                return
            }
        }
    }
    
    private func formedAndSend(stationDictionary: [String : Any]){
        guard let id = stationDictionary["id"] as? String else { return }
        ref.child("gasStations/\(id)").setValue(stationDictionary) { (error, ref) in
            if let error = error{
                print(error.localizedDescription)
            }else{
                print("added succesful")
            }
        }
    }
    
    func changeGasStation(station: GasStation){
        guard let name = station.name,
                    let latitude = station.latitude,
                    let longitude = station.longitude,
                    let type = station.type,
                    let count = station.count.value,
                    let price = station.price.value,
                    count != 0,
                    price != 0,
                    let date = station.date.getStringFrom(),
                    let idUser = station.idUser.value
                else {
                    return
                }
                
                var stationDictionary: [String : Any] = [
                    "id": station.id,
                    "name": name,
                    "latitude": latitude,
                    "longitude": longitude,
                    "type": type,
                    "count": count,
                    "price": price,
                    "date": date,
                    "idUser": idUser,
                    "synchronized": true
                ]

                if let address = station.address{
                    stationDictionary["address"] = address
                    formedAndSend(stationDictionary: stationDictionary)
                }else{
                    let location = CLLocation(latitude: CLLocationDegrees((latitude as NSString).doubleValue), longitude: CLLocationDegrees((longitude as NSString).doubleValue))
//                    Storage.shared.getAddressString(location: location) { (address) in
//                        guard let address = address else { return }
//                        stationDictionary["address"] = address
//                        self.formedAndSend(stationDictionary: stationDictionary)
//                    }
                    if ReachabilityInternet.isConnectedToNetwork(){
                        Storage.shared.getAddressString(location: location) { (address) in
                            guard let address = address else { return }
                            stationDictionary["address"] = address
                            self.formedAndSend(stationDictionary: stationDictionary)
                        }
                    }else{
                        return
                    }
                }
    }
    
    func removeGasStation(id: String){
        ref.child("gasStations/\(id)").removeValue { (error, ref) in
            if let error = error{
                print(error.localizedDescription)
            }else{
                print("Removing success")
            }
        }
    }
}


