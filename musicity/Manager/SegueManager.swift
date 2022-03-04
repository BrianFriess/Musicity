//
//  ValueSegue.swift
//  musicity
//
//  Created by Brian Friess on 02/03/2022.
//

import Foundation

//all the Segue is here
enum SegueManager {
    case goToMusicitySegue
    case goToFirstConnexionSegue
    case goToChoiceInstruSegue
    case goToWelcomeSegue
    case goToMusicityFromWelcome
    case segueDisconnect
    case goToMissInformation
    case segueToFilter
    case goToViewUserProfil
    case segueToFirstTimeMessenger
    case segueToMessenger
    case segueToViewProfilInMessenger
    
    var returnSegueString : String {
        switch self {
        case .goToMusicitySegue:
            return "goToMusicitySegue"
        case .goToFirstConnexionSegue:
            return "goToFirstConnexionSegue"
        case .goToChoiceInstruSegue:
            return "goToChoiceInstruSegue"
        case .goToWelcomeSegue:
            return "goToWelcomeSegue"
        case .goToMusicityFromWelcome:
            return "goToMusicityFromWelcome"
        case .segueDisconnect:
            return "segueDisconnect"
        case .goToMissInformation:
            return "goToMissInformation"
        case .segueToFilter:
            return "segueToFilter"
        case .goToViewUserProfil:
            return "goToViewUserProfil"
        case .segueToFirstTimeMessenger:
            return "segueToFirstTimeMessenger"
        case .segueToMessenger:
            return "segueToMessenger"
        case .segueToViewProfilInMessenger:
            return "segueToViewProfilInMessenger"
        }
    }
    
}
    


