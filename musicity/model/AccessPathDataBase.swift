//
//  AccessPathDataBase.swift
//  musicity
//
//  Created by Brian Friess on 27/11/2021.
//

import Foundation

enum DataBaseAccessPath {
    case username
    case BandOrMusician
    case publicInfoUser
    case NbMember
    case Style
    case Instrument
    case userLocation
    case Bio
    case YoutubeUrl
    case messenger
    case messengerUserId
    case distance
    case search
    case notification
    case notificationBanner
    
    var returnAccessPath : String{
        switch self{
        case .username:
            return "username"
        case .BandOrMusician:
            return "BandOrMusician"
        case .publicInfoUser:
            return "publicInfoUser"
        case .NbMember:
            return "NbMember"
        case .Style:
            return "Style"
        case .Instrument:
            return "Instrument"
        case .userLocation:
            return "UserLocation"
        case .Bio:
            return "Bio"
        case .YoutubeUrl:
            return "YoutubeUrl"
        case .messenger:
            return "Messenger"
        case .messengerUserId:
            return "MessengerUserId"
        case .distance:
            return "Distance"
        case .search:
            return "Search"
        case .notification:
            return "Notification"
        case .notificationBanner:
            return "NotificationBanner"
        }
    }
}
