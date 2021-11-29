//
//  AccessPathDataBase.swift
//  musicity
//
//  Created by Brian Friess on 27/11/2021.
//

import Foundation

enum DataBaseAccessPath{
    case firstName
    case lastName
    case age
    case username
    case BandOrMusician
    case PersonalInfoUser
    case publicInfoUser
    case NbMember
    case NbInstrument
    case MusiqueInfoUser
    case Style
    
    var returnAccessPath : String{
        switch self{
        case.firstName:
            return "FirstName"
        case .lastName:
            return "LastName"
        case .age:
            return "Age"
        case .username:
            return "username"
        case .BandOrMusician:
            return "BandOrMusician"
        case .PersonalInfoUser:
            return "PersonalInfoUser"
        case .publicInfoUser:
            return "publicInfoUser"
        case .NbMember:
            return "NbMember"
        case .NbInstrument:
            return "NbInstrument"
        case .MusiqueInfoUser:
            return "MusiqueInfoUser"
        case .Style:
            return "Style"
        }
    }
}
