//
//  CustomCreateProfilView.swift
//  musicity
//
//  Created by Brian Friess on 22/11/2021.
//

import UIKit

class CustomCreateProfilView: UIView {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet var stickTextField: [UIView]!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var stackFirstname: UIStackView!
    @IBOutlet weak var stackLastname: UIStackView!
    @IBOutlet weak var stackAge: UIStackView!
    @IBOutlet weak var labelView: UILabel!
    @IBOutlet weak var nbMembreTextField: UILabel!
    @IBOutlet weak var stackViewNbMembre: UIStackView!
    
    func configureView(){
        configureButton()
        configureStick()
    }
    
    private func configureStick(){
        let count = stickTextField.count
        for i in 0 ..< count{
            stickTextField[i].layer.cornerRadius = 2
        }
    }
    

    private func configureButton(){
        nextButton.layer.cornerRadius = 20
    }
    
    
    private func configureTextFieldIfItMusician(){
        pickerView.isHidden = true
        firstNameTextField.attributedPlaceholder = NSAttributedString(string: "Prenom", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.3)])
        lastNameTextField.attributedPlaceholder = NSAttributedString(string: "Nom", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.3)])
        ageTextField.attributedPlaceholder = NSAttributedString(string: "Age", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.3)])
        labelView.text = "instrument(s)"
        stackViewNbMembre.isHidden = true
    }
    
    private func configureTextFieldIfItsBand(){
        stackFirstname.isHidden = true
        stackLastname.isHidden = true
        stackAge.isHidden = true
        labelView.text = "instrument(s)"
        nbMembreTextField.text = "Membre du groupe"
    }
    
    enum BandOrMusician{
        case band
        case musician
    }
    
   func customStackIfItsBandOrMusician(_ bandOrMusician : BandOrMusician){
        switch bandOrMusician{
        case .band:
            configureTextFieldIfItsBand()
        case .musician:
            configureTextFieldIfItMusician()
        }
    }
    
}
