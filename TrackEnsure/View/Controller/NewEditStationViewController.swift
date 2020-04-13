//
//  NewEditStationViewController.swift
//  TrackEnsure
//
//  Created by Artem Shpilka on 4/9/20.
//  Copyright © 2020 Artem Shpilka. All rights reserved.
//

import UIKit
import MapKit
import DropDown

class NewEditStationViewController: UIViewController {
    
    var viewModel: NewEditStationViewControllerViewModelType?
    var isCreateNewGasStation: Bool = true
    var editIndex: Int = 0
    
    @IBOutlet weak var deliverButton: UIButton!
    var deliverDropDown = DropDown()
    
    @IBOutlet weak var typeButton: UIButton!
    var typeDropDown = DropDown()
    
    @IBOutlet weak var countTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = NewEditStationViewControllerViewModel()
        guard var viewModel = viewModel else { return }
        
        print(isCreateNewGasStation)
        
        
        deliverDropDown.anchorView = deliverButton
        deliverDropDown.dataSource = viewModel.namesOfGasStations()
        
        deliverDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            viewModel.newDeliverName = item
            self.deliverButton.setTitle(item, for: .normal)
            self.deliverButton.tintColor = .black
        }
        
        typeDropDown.anchorView = typeButton
        typeDropDown.dataSource = viewModel.namesOfTypePetrols()
        
        typeDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            viewModel.newTypeName = TypeOfPetrol.getTypeOfPetrol(valueTranslated: item).rawValue
            self.typeButton.setTitle(item, for: .normal)
            self.typeButton.tintColor = .black
        }
        
        countTextField.delegate = self
        countTextField.addDoneButtonToKeyboard(myAction: #selector(countTextField.resignFirstResponder))
        countTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        priceTextField.delegate = self
        priceTextField.addDoneButtonToKeyboard(myAction: #selector(priceTextField.resignFirstResponder))
        priceTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
        mapView.delegate = self
        LocationManager.locationManager.delegate = self
        LocationManager.shared.requestAuthorizationStatus()
        
        
        if !isCreateNewGasStation{
            guard let stationForEdit = viewModel.getStation(row: editIndex) else { return }
            self.deliverButton.setTitle(stationForEdit.name, for: .normal)
            viewModel.newDeliverName = stationForEdit.name
            self.deliverButton.tintColor = .black
            
            if let stationType = stationForEdit.type{
                let type = TypeOfPetrol.getTypeOfPetrol(value: stationType).translated()
                self.typeButton.setTitle(type, for: .normal)
                viewModel.newTypeName = TypeOfPetrol.getTypeOfPetrol(value: stationType).rawValue
                self.typeButton.tintColor = .black
            }
            
            if let count = stationForEdit.count.value, let price = stationForEdit.price.value{
                countTextField.text = count.countToVolume().toString()
                viewModel.newCount = count.countToVolume().toString()
                priceTextField.text = price.priceToMoney().toString()
                viewModel.newPrice = price.priceToMoney().toString()
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopUpdatingLocation()
    }
    
    
    @IBAction func saveButtonAction(_ sender: UIBarButtonItem) {
        guard let viewModel = viewModel else { return }
        if isCreateNewGasStation{
            viewModel.getNewGasStation { (station) in
                guard let newGasStation = station else {
                    self.showAllert(title: "Внимание", message: "Все поля должны быть заполнены")
                    return
                }
                viewModel.addNewGasStation(newGasStation: newGasStation) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }else{
            viewModel.editGasStation(row: editIndex) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }


    @IBAction func chooseDeliverButtonAction(_ sender: UIButton) {
        deliverDropDown.show()
    }
    
    @IBAction func chooseTypeButtonAction(_ sender: UIButton) {
        typeDropDown.show()
    }
    
    func showAllert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension NewEditStationViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        guard let viewModel = viewModel else { return }
        viewModel.newPlaceLocationAnnotation.coordinate = mapView.centerCoordinate
    }
}

extension NewEditStationViewController: CLLocationManagerDelegate{
    func startUpdatingLocation() {
        LocationManager.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        LocationManager.locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation(){
        LocationManager.locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            self.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard var viewModel = viewModel, let lastLocation = locations.last, viewModel.isShowToCurrentLocation == true else { return }

        viewModel.setupMapView(view: mapView, location: lastLocation.coordinate, animated: true)
        viewModel.isShowToCurrentLocation = false
    }
}


extension NewEditStationViewController: UITextFieldDelegate{
    @objc
    func textFieldDidChange(textField: UITextField){
        guard var viewModel = viewModel else { return }

        switch textField {
        case countTextField:
            viewModel.newCount = textField.text ?? "00.00"
        case priceTextField:
            viewModel.newPrice = textField.text ?? "00.00"
        default:
            print("another texField")
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        if string == "" { return true }
        
        switch text.count {
        case 0, 1, 3, 4:
            return true
        case 2:
            textField.text = text + "."
            return true
        default:
            return false
        }
    }
}

extension UITextField{
    
    func addDoneButtonToKeyboard(myAction:Selector?){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: myAction)
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }

}
