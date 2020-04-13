//
//  StationTableViewCell.swift
//  TrackEnsure
//
//  Created by Artem Shpilka on 4/8/20.
//  Copyright © 2020 Artem Shpilka. All rights reserved.
//

import UIKit
import SnapKit
import MapKit

class StationTableViewCell: UITableViewCell {
    
    lazy var box = UIView()
    lazy var mapView = MKMapView()
    lazy var blurView = UIVisualEffectView()
    lazy var nameLabel = UILabel()
    lazy var typeLabel = UILabel()
    lazy var countLabel = UILabel()
    lazy var priceLabel = UILabel()
    lazy var totalSpentLabel = UILabel()
    
    var colorText: UIColor = .white
    
    weak var viewModel: StationTableViewCellViewModelType?{
        willSet(viewModel){
            guard let viewModel = viewModel else { return }
            nameLabel.text = viewModel.name
            setupMapView(location: viewModel.location)
            typeLabel.text = viewModel.type.translated()
            countLabel.text = "Объем: \(viewModel.count.countToVolume())л"
            priceLabel.text = "Цена за литр: \(viewModel.price.priceToMoney())"
            totalSpentLabel.text = "Сума: \(viewModel.totalSpent.toString())"
        }
    }
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleBlurView)))
    }
    
    
    
    deinit {
        print("deinit")
        blurView.alpha = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func toggleBlurView(){
        if blurView.alpha == 1{
            UIView.animate(withDuration: 0.3) {
                self.blurView.alpha = 0
            }
        }else{
            UIView.animate(withDuration: 0.3) {
                self.blurView.alpha = 1
            }
        }
    }
    
    func showBlurView(){
        blurView.alpha = 1
    }
    
    func setupUI(){
        addSubview(box)
        box.addSubview(mapView)
        box.addSubview(blurView)
        blurView.contentView.addSubview(nameLabel)
        blurView.contentView.addSubview(typeLabel)
        blurView.contentView.addSubview(countLabel)
        blurView.contentView.addSubview(priceLabel)
        blurView.contentView.addSubview(totalSpentLabel)
        
        box.layer.cornerRadius = 16
        box.layer.shadowColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1).cgColor
        box.layer.shadowOpacity = 1
        box.layer.shadowRadius = 11
        box.layer.shadowOffset = .init(width: 0, height: 4)
        box.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).inset(16)
            make.left.equalTo(self.snp.left).inset(16)
            make.bottom.equalTo(self.snp.bottom).inset(16)
            make.right.equalTo(self.snp.right).inset(16)
        }
        
        mapView.layer.cornerRadius = box.layer.cornerRadius
        mapView.isScrollEnabled = false
        mapView.snp.makeConstraints { (make) in
            make.top.equalTo(box.snp.top)
            make.left.equalTo(box.snp.left)
            make.bottom.equalTo(box.snp.bottom)
            make.right.equalTo(box.snp.right)
        }
        
        blurView.layer.cornerRadius = box.layer.cornerRadius
        blurView.clipsToBounds = true
        blurView.effect = UIBlurEffect(style: .dark)
        blurView.alpha = 1
        blurView.snp.makeConstraints { (make) in
            make.top.equalTo(box.snp.top)
            make.left.equalTo(box.snp.left)
            make.bottom.equalTo(box.snp.bottom)
            make.right.equalTo(box.snp.right)
        }
        
        
        nameLabel.textAlignment = .right
        nameLabel.textColor = colorText
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(box.snp.top).inset(16)
            make.right.equalTo(box.snp.right).inset(16)
            make.left.equalTo(box.snp.left).inset(16)
        }
        
        typeLabel.textColor = colorText
        typeLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        typeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(16)
            make.left.equalTo(box.snp.left).inset(16)
            make.right.equalTo(box.snp.right).inset(16)
        }

        countLabel.textColor = colorText
        countLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        countLabel.snp.makeConstraints { (make) in
            make.top.equalTo(typeLabel.snp.bottom).offset(8)
            make.left.equalTo(typeLabel.snp.left).inset(16)
            make.right.equalTo(box.snp.right).inset(16)
        }

        priceLabel.textColor = colorText
        priceLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        priceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(countLabel.snp.bottom).offset(8)
            make.left.equalTo(typeLabel.snp.left).inset(16)
            make.right.equalTo(box.snp.right).inset(16)
        }

        totalSpentLabel.textAlignment = .right
        totalSpentLabel.textColor = colorText
        totalSpentLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        totalSpentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(box.snp.left).inset(16)
            make.bottom.equalTo(box.snp.bottom).inset(16)
            make.right.equalTo(box.snp.right).inset(16)
        }
        
    }
    
    func setupMapView(location: CLLocation){
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        
        let allAnotations = mapView.annotations
        mapView.removeAnnotations(allAnotations)
        
        mapView.addAnnotation(annotation)
        let distance: CLLocationDistance = 5000
        let mapRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: distance, longitudinalMeters: distance)
        mapView.setRegion(mapRegion, animated: false)
    }
    
}
