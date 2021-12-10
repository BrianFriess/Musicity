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
    
    @IBOutlet var stick: [UIView]!

    
    @IBOutlet weak var segmentedControl: UISegmentedControl!


    
    func configureView(){
        configureTextField()
        configureStick()
    }
    
    func configureTextField(){
        userNameTextField.attributedPlaceholder = NSAttributedString(
            string: "Nom d'utilisateur",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.3)])
        
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "Mot de passe",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.3)])
        
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "E-mail",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.3)])
    }
    
    func configureStick(){
        let count = stick.count
        for i in 0 ..< count{
            stick[i].layer.cornerRadius = 1.5
        }
    }
        
    func configureBandOrMusicien(){
        switch segmentedControl.selectedSegmentIndex{
        case 0 :
            userNameTextField.attributedPlaceholder = NSAttributedString(string: "Nom d'utilisateur", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.3)])
        case 1 :
            userNameTextField.attributedPlaceholder = NSAttributedString(string: "Nom du groupe", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.3)])
        default:
            break
        }
    } 
}
 
