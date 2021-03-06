//
//  AlertManager.swift
//  musicity
//
//  Created by Brian Friess on 21/11/2021.
//

import Foundation
import UIKit

struct AlertManager {
    //we create an enumeration for our message alerteVC
    enum AlertType {
        case errorCreateUser
        case lessSixPassword
        case emptyUsername
        case emptyEmail
        case falseEmail
        case errorConnexion
        case emptyPassword
        case emptyNbInstrument
        case emptyNbMembre
        case errorGetInfo
        case errorSetInfo
        case errorLogOut
        case errorImage
        case cantAccessPhotoLibrary
        case emptyInstrument
        case emptyProfilPicture
        case errorGeolocalisation
        case errorCheckAroundUs
        case deniedGeolocalisation
        case emptyStyle
        case tooMuchCara
        case youtubeLink
        case messageError
        
        var title : String {
            switch self {
            case .errorCreateUser:
                return "Problème de creation du compte!"
            case .lessSixPassword:
                return "Problème de creation du compte!"
            case .emptyUsername:
                return "Problème de creation du compte!"
            case .emptyEmail:
                return "Problème de creation du compte!"
            case .falseEmail:
                return "Problème de creation du compte!"
            case .errorConnexion:
                return "Problème de connexion"
            case .emptyPassword:
                return "Problème de connexion"
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
            case .errorGeolocalisation:
                return "Geolocalisation"
            case .errorCheckAroundUs:
                return "Il n'y a personne !"
            case .deniedGeolocalisation:
                return "Geolocalisation"
            case .emptyStyle:
                return "Champs vide"
            case .tooMuchCara:
                return "Trop de caractère"
            case.youtubeLink:
                return "Lien Youtube"
            case .messageError:
                return "Message"
            }
        }
        
        var description : String {
            switch self {
            case .errorCreateUser:
                return "Votre compte n'a pas pu être crée, merci de réessayer"
            case .lessSixPassword:
                return "Votre mot de passe doit faire plus de 6 caractères"
            case .emptyUsername:
                return "Le champs nom d'utilsateur est vide"
            case .emptyEmail:
                return "Le champs e-mail est vide"
            case .falseEmail:
                return "E-mail non valide ou déjà utilisé"
            case .errorConnexion:
                return "E-mail ou mot de passe eroné"
            case .emptyPassword:
                return "Le champs mot de passe est vide"
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
                return "Merci de renseigner au moins un instruments"
            case .emptyProfilPicture:
                return "Il manque votre photo de profil"
            case .errorGeolocalisation:
                return "Une erreur avec votre géolocalisation est survenue"
            case .errorCheckAroundUs:
                return "Aucun musicien trouvé autour de vous"
            case .deniedGeolocalisation:
                return "Merci de verifier vos paramètres de geolocalisation"
            case .emptyStyle:
                return "Merci de renseigner au moins un style"
            case .tooMuchCara:
                return "1500 caratères max"
            case .youtubeLink:
                return "Ce n'est pas un lien Youtube"
            case .messageError:
                return "Erreur lors de l'envoie du message"
            }
        }
    }
    
    //we create an alert VC
    func alertVc(_ message: AlertType, _ controller : UIViewController) {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: "\(message.title)", message: "\(message.description)", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            controller.present(alertVC, animated: true, completion: nil)
       }
    }
    
    //we create an alert and we display the choose for open the setting of the iphone 
    func locationAlert(_ message: AlertType, _ controller : UIViewController) {
       DispatchQueue.main.async {
            let alertVC = UIAlertController(title: "\(message.title)", message: "\(message.description)", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
            alertVC.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Ouvrir les paramètres", style: .default) { action in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            alertVC.addAction(openAction)
        
        controller.present(alertVC, animated : true, completion : nil)
       }
    }
    
}
