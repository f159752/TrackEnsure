//
//  NewEditStationViewControllerViewModelType.swift
//  TrackEnsure
//
//  Created by Artem Shpilka on 4/10/20.
//  Copyright © 2020 Artem Shpilka. All rights reserved.
//

import Foundation
import MapKit

protocol NewEditStationViewControllerViewModelType {
    var newDeliverName: String? { get set }
    var newTypeName: String? { get set }
    var newCount: String { get set }
    var newPrice: String { get set }
    var newLocation: CLLocation? { get }
    var newPlaceLocationAnnotation: MKPointAnnotation { get set}
    
    var isShowToCurrentLocation: Bool { get set }
    
    func namesOfGasStations() -> [String]
    func namesOfTypePetrols() -> [String]
    func addNewGasStation(newGasStation: GasStation, completion: @escaping ()->())
    func setupMapView(view: MKMapView, location: CLLocationCoordinate2D, animated: Bool)
    func getNewGasStation(completion: @escaping (GasStation?)->())
    func getStation(row: Int) -> GasStation?
    func editGasStation(row: Int, completion: @escaping ()->())
}
