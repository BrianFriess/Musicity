//
//  CustomConnextionView.swift
//  musicity
//
//  Created by Brian Friess on 21/11/2021.
//

import UIKit

class CustomConnextionView: UIView {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet var stick: [UIView]!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var incriptionButton: UIButton!
    @IBOutlet weak var connexionButton: CustomOrangeButton!
    
    func configureView(){
        configureTextField()
        configureStick()
        configureButton()
    }
    
    private func configureTextField(){
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "E-mail",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.orange.withAlphaComponent(0.3)])
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "Mot de passe",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.orange.withAlphaComponent(0.3)])
    }
    
    private func configureStick(){
        let count = stick.count
        for i in 0 ..< count{
            stick[i].layer.cornerRadius = 1.5
        }
    }
    
    private func configureButton(){
        incriptionButton.layer.cornerRadius = 20
        incriptionButton.layer.borderWidth = 3
        incriptionButton.layer.borderColor = UIColor.systemOrange.cgColor
    }
    
    enum IsLoad{
        case isLoad
        case isOnLoad
    }
    
    func connexionIsLoadOrNot(_ isLoad : IsLoad){
        switch isLoad {
        case .isLoad:
            self.connexionButton.isHidden = false
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        case .isOnLoad:
            self.connexionButton.isHidden = true
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        }
    }
}
