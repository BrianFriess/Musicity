//
//  AccessPathDataBase.swift
//  musicity
//
//  Created by Brian Friess on 27/11/2021.
//

import Foundation

enum DataBaseAccessPath {
    case users
    case username
    case bandOrMusician
    case publicInfoUser
    case nbMember
    case style
    case instrument
    case userLocation
    case bio
    case youtubeUrl
    case messenger
    case messengerUserId
    case distance
    case search
    case notification
    case notificationBanner
    case band
    case member
    case all
    case musician
    case messages
    case profilImage
    case idResult
    
    var returnAccessPath : String {
        switch self {
        case .users:
            return "users"
        case .username:
            return "username"
        case .bandOrMusician:
            return "BandOrMusician"
        case .publicInfoUser:
            return "publicInfoUser"
        case .nbMember:
            return "NbMember"
        case .style:
            return "Style"
        case .instrument:
            return "Instrument"
        case .userLocation:
            return "UserLocation"
        case .bio:
            return "Bio"
        case .youtubeUrl:
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
        case .band:
            return "Band"
        case .member:
            return "Membre(s)"
        case .all:
            return "All"
        case .musician:
            return "Musician"
        case .messages:
            return "Messages"
        case .profilImage:
            return "ProfilImage/profilImage.png"
        case .idResult:
            return "idResult"
        }
    }
    
}
