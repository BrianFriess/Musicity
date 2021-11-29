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
        case errorCreateUser
        case LessSixPassword
        case EmptyUsername
        case EmptyEmail
        case FalseEmail
        case ErrorConnexion
        case emptyPassword
        case emptyFirstname
        case emptyLastename
        case emptyAge
        case emptyCity
        case emptyCountry
        case emptyNbInstrument
        case emptyNbMembre
        case errorGetInfo
        case errorSetInfo
        case errorLogOut
        case errorImage
        case cantAccessPhotoLibrary
        case emptyInstrument
        case emptyProfilPicture
        
        
        var title : String{
            switch self{
            case .errorCreateUser:
                return "Problème de creation du compte!"
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
            case .emptyFirstname:
                return "Champs vide"
            case .emptyLastename:
                return "Champs vide"
            case .emptyAge:
                return "Champs vide"
            case .emptyCity:
                return "Champs vide"
            case .emptyCountry:
                return "Champs vide"
            case .emptyNbInstrument:
                return "Champs vide"
            case .emptyNbMembre:
                return "Champs vide"
            case .errorGetInfo:
                return "Problème de creation du compte!"
            case .errorSetInfo:
                return "Problème de mise à jour"
            case .errorLogOut:
                return "Erreur deconnexion"
            case .errorImage:
                return "Erreur du chargement de l'image"
            case .cantAccessPhotoLibrary:
                return "Erreur d'accès à la librairie"
            case .emptyInstrument:
                return "Champs vide"
            case .emptyProfilPicture:
                return "Photo de profil"
            }
        }
        
        var description : String{
            switch self{
            case .errorCreateUser:
                return "Votre compte n'a pas pu être crée, merci de réessayer"
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
            case .emptyFirstname:
                return "Le champs prenom est vide"
            case .emptyLastename:
                return "Le champs nom de famille est vide"
            case .emptyAge:
                return "Le champs age est vide"
            case .emptyCity:
                return "Le champs ville est vide"
            case .emptyCountry:
                return "Le champs pays est vide"
            case .emptyNbInstrument:
                return "Il manque le nombre d'instrument"
            case .errorGetInfo:
                return "problème de connexion, merci de réessayer"
            case .emptyNbMembre:
                return "Il manque le nombre de membre dans votre groupe"
            case .errorSetInfo:
                return "Les données n'ont pas pu être mis à jour, merci de réessayer"
            case .errorLogOut:
                return "Il y a eu un problème à la deconnexion, merci de réessayer"
            case .errorImage:
                return "L'image n'a pas pu être chargé, merci de réessayer"
            case .cantAccessPhotoLibrary:
                return "Merci de verifier vos paramètres pour accèder à la librairie"
            case .emptyInstrument:
                return "Merci de renseigner tous les instruments"
            case .emptyProfilPicture:
                return "Il manque votre photo de profil"
            }
        }
    }
    

    
    func alerteVc(_ message: AlerteType, _ controller : UIViewController){
        let alertVC = UIAlertController(title: "\(message.title)", message: "\(message.description)", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        controller.present(alertVC, animated: true, completion: nil)
        }
}
