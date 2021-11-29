//
//  AlerteManager.swift
//  musicity
//
//  Created by Brian Friess on 21/11/2021.
//

import Foundation

import Foundation
import UIKit

struct AlerteManager{
    
    //we create an enumeration for our message alerteVC
    enum AlerteType{
        case LessSixPassword
        case EmptyUsername
        case EmptyEmail
        case FalseEmail
        case ErrorConnexion
        case emptyPassword
        
        var title : String{
            switch self{
            case .LessSixPassword:
                return "Problème de creation du compte!"
            case .EmptyUsername:
                return "Problème de creation du compte!"
            case .EmptyEmail:
                return "Problème de creation du compte!"
            case .FalseEmail:
                return "Problème de creation du compte!"
            case .ErrorConnexion:
                return "Problème de connexion"
            case .emptyPassword:
                return "Problème de connexion"
            }
        }
        
        var description : String{
            switch self{
            case .LessSixPassword:
                return "Votre mot de passe doit faire plus de 6 caractères"
            case .EmptyUsername:
                return "Le champs nom d'utilsateur est vide"
            case .EmptyEmail:
                return "Le champs e-mail est vide"
            case .FalseEmail:
                return "E-mail non valide ou déjà utilisé"
            case .ErrorConnexion:
                return "E-mail ou mot de passe eroné"
            case .emptyPassword:
                return "Le champs mot de passe est vide"
            }
        }
    }
    

    
    func alerteVc(_ message: AlerteType, _ controller : UIViewController){
        let alertVC = UIAlertController(title: "\(message.title)", message: "\(message.description)", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        controller.present(alertVC, animated: true, completion: nil)
        }
}
