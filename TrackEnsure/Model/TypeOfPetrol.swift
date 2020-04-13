//
//  TypeOfPetrol.swift
//  TrackEnsure
//
//  Created by Artem Shpilka on 4/8/20.
//  Copyright © 2020 Artem Shpilka. All rights reserved.
//

import Foundation

enum TypeOfPetrol: String{
    case gasoline
    case diesel
    case none
    
    static func getTypeOfPetrol(valueTranslated: String) -> TypeOfPetrol{
        switch valueTranslated {
        case TypeOfPetrol.gasoline.translated():
            return .gasoline
        case TypeOfPetrol.diesel.translated():
            return .diesel
        default:
            return .none
        }
    }
    static func getTypeOfPetrol(value: String) -> TypeOfPetrol{
        switch value {
        case TypeOfPetrol.gasoline.rawValue:
            return .gasoline
        case TypeOfPetrol.diesel.rawValue:
            return .diesel
        default:
            return .none
        }
    }
    
    
    func translated() -> String{
        switch self {
        case .gasoline:
            return "Бензин"
        case .diesel:
            return "Дизель"
        default:
            return "Топливо не указано"
        }
    }
}

