//
//  CustomConnexionView.swift
//  musicity
//
//  Created by Brian Friess on 19/11/2021.
//

import UIKit

class CustomCreateUserView: UIView {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var emailStick: UIView!
    @IBOutlet weak var passwordStick: UIView!
    @IBOutlet weak var userNameStick: UIView!
    
    
    @IBOutlet weak var buttonSinscrire: UIButton!
    @IBOutlet weak var buttonConnexion: UIButton!
    
    func configureTextField(){
        userNameTextField.attributedPlaceholder = NSAttributedString(
            string: "Nom d'utilisateur",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.3)])
        userNameStick.layer.cornerRadius = 2
        
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "Mot de passe",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.3)])
        passwordStick.layer.cornerRadius = 2
        
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "E-mail",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.3)])
        emailStick.layer.cornerRadius = 2
    }
    
    func configureButton(){
        buttonConnexion.layer.cornerRadius = 20
        buttonConnexion.layer.borderWidth = 3
        buttonConnexion.layer.borderColor = UIColor.systemOrange.cgColor
        buttonSinscrire.layer.cornerRadius = 20
        
    }
}
 
