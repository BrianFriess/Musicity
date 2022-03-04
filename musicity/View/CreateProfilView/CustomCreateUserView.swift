//
//  CustomConnexionView.swift
//  musicity
//
//  Created by Brian Friess on 19/11/2021.
//

import UIKit


final class CustomCreateUserView: UIView {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var activityController: UIActivityIndicatorView!
    @IBOutlet var stick: [UIView]!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var inscriptionButton: CustomOrangeButton!
    
    func configureView() {
        configureTextField()
        configureStick()
    }
    
    //configure the information for the view
    private func configureTextField() {
        userNameTextField.attributedPlaceholder = NSAttributedString(
            string: "Nom d'utilisateur",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.orange.withAlphaComponent(0.3)])
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "Mot de passe",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.orange.withAlphaComponent(0.3)])
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "E-mail",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.orange.withAlphaComponent(0.3)])
    }
    
    //configure all the sticks
    private func configureStick() {
        let count = stick.count
        for i in 0 ..< count {
            stick[i].layer.cornerRadius = 1.5
        }
    }
        
    //check if it's a band or musician thanks to the segmented for display the good information
    func configureBandOrMusicien() {
        switch segmentedControl.selectedSegmentIndex {
        case 0 :
            userNameTextField.attributedPlaceholder = NSAttributedString(string: "Nom d'utilisateur", attributes: [NSAttributedString.Key.foregroundColor: UIColor.orange.withAlphaComponent(0.3)])
        case 1 :
            userNameTextField.attributedPlaceholder = NSAttributedString(string: "Nom du groupe", attributes: [NSAttributedString.Key.foregroundColor: UIColor.orange.withAlphaComponent(0.3)])
        default:
            break
        }
    }
    
    enum IsLoad {
        case isLoad
        case isOnLoad
    }
    
    //display the activity indicator or not
    func connexionIsLoadOrNot(_ isLoad : IsLoad) {
        switch isLoad {
        case .isLoad:
            self.inscriptionButton.isHidden = false
            self.activityController.isHidden = true
            self.activityController.stopAnimating()
        case .isOnLoad:
            self.inscriptionButton.isHidden = true
            self.activityController.isHidden = false
            self.activityController.startAnimating()
        }
    }
    
}
 
