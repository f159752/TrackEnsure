//
//  NewEditStationViewControllerViewModel.swift
//  TrackEnsure
//
//  Created by Artem Shpilka on 4/10/20.
//  Copyright © 2020 Artem Shpilka. All rights reserved.
//

import Foundation
import MapKit


class NewEditStationViewControllerViewModel: NewEditStationViewControllerViewModelType {
    var newDeliverName: String? = nil
    
    var newTypeName: String? = nil
    
    var newCount: String = "00.00"
    
    var newPrice: String = "00.00"
    
    var newLocation: CLLocation?{
        return CLLocation(latitude: newPlaceLocationAnnotation.coordinate.latitude, longitude: newPlaceLocationAnnotation.coordinate.longitude)
    }
    
    var isShowToCurrentLocation: Bool = true
    
    var newPlaceLocationAnnotation = MKPointAnnotation()
    
    func namesOfGasStations() -> [String]{
        return Storage.shared.namesOfGasStations
    }
    
    func namesOfTypePetrols() -> [String]{
        return [TypeOfPetrol.gasoline.translated(), TypeOfPetrol.diesel.translated()]
    }
    
    func addNewGasStation(newGasStation: GasStation, completion: @escaping ()->()){
        Storage.shared.addNewGasStation(newGasStation) {
            completion()
        }
    }
    
    func setupMapView(view: MKMapView, location: CLLocationCoordinate2D, animated: Bool = false){
        newPlaceLocationAnnotation = MKPointAnnotation()
        newPlaceLocationAnnotation.coordinate = location
        view.addAnnotation(newPlaceLocationAnnotation)
        let distance: CLLocationDistance = 5000
        let mapRegion = MKCoordinateRegion(center: location, latitudinalMeters: distance, longitudinalMeters: distance)
        view.setRegion(mapRegion, animated: animated)
    }
    
    func getNewGasStation(completion: @escaping (GasStation?)->()){
        guard let name = newDeliverName,
            let location = newLocation,
            let type = newTypeName,
            let count = Double(newCount),
            let price = Double(newPrice),
            count != 0,
            price != 0
        else { completion(nil)
            return
        }

        let newStation = GasStation()
        newStation.name = name
        newStation.latitude = String(describing: location.coordinate.latitude)
        newStation.longitude = String(describing: location.coordinate.longitude)

        newStation.type = type
        newStation.count.value = Int(count * 100)
        newStation.price.value = Int(price * 100)
        newStation.idUser.value = User.shared.idDriver
        newStation.synchronized = false
        
        getAddress(location: location) { (address) in
            newStation.address = address
            completion(newStation)
        }
    }
    
    func getStation(row: Int) -> GasStation?{
        return Storage.shared.invitedGasStations[row]
    }
    
    func editGasStation(row: Int, completion: @escaping ()->()){
        guard let name = newDeliverName,
            let location = newLocation,
            let type = newTypeName,
            let count = Double(newCount),
            let price = Double(newPrice),
            count != 0,
            price != 0
        else { completion()
            return
        }

        let stationToSave = GasStation()
        
        stationToSave.name = name
        stationToSave.latitude = String(describing: location.coordinate.latitude)
        stationToSave.longitude = String(describing: location.coordinate.longitude)

        stationToSave.type = type
        stationToSave.count.value = Int(count * 100)
        stationToSave.price.value = Int(price * 100)
        stationToSave.idUser.value = User.shared.idDriver
        stationToSave.synchronized = false

        getAddress(location: location) { (address) in
            stationToSave.address = address
            Storage.shared.editGasStation(stationToSave, row: row) {
                completion()
            }
        }
    }

    
    func getAddress(location: CLLocation, completion: @escaping (String?)->()){
        Storage.shared.getAddressString(location: location) { (address) in
            completion(address)
        }
    }

    
}
