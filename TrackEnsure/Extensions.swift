//
//  Extensions.swift
//  TrackEnsure
//
//  Created by Artem Shpilka on 4/9/20.
//  Copyright © 2020 Artem Shpilka. All rights reserved.
//

import Foundation
//import Firebase

extension Int{
    func toString() -> String{
        return String(describing: self)
    }
    
    func countToString() -> String{
        return String(describing: Double(self) / 100)
    }
    func countToVolume() -> Double{
        return Double(self) / 100
    }
    
    func priceToString() -> String{
        return String(describing: Double(self) / 100)
    }
    func priceToMoney() -> Double{
        return Double(self) / 100
    }
}
extension Double{
    func toString() -> String{
        return String(describing: self)
    }
    func moneyToPrice() -> Int{
        return Int(self * 100)
    }
    func volumeToCount() -> Int{
        return Int(self * 100)
    }
}

extension Date{
    func getStringFrom() -> String?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        return dateFormatter.string(from: self)
    }
}

extension String{
    func getDateFrom() -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        return dateFormatter.date(from: self)
    }
}

extension Collection {
    var jsonData: Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
    }
}
