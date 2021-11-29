//
//  CustomSecondCreateProfil.swift
//  musicity
//
//  Created by Brian Friess on 26/11/2021.
//

import UIKit

class CustomSecondCreateProfil: UIView {

    
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func configureButton(){
        photoButton.layer.cornerRadius = 60
        photoButton.layer.borderWidth = 2
        photoButton.layer.borderColor = UIColor.white.cgColor
        finishButton.layer.cornerRadius = 20
        activityIndicator.isHidden = true
    }
    
    enum Loading{
        case isloading
        case isLoad
    }
    
    
    func loadPhoto(_ loadind : Loading){
        switch loadind {
        case .isloading:
            photoButton.isHidden = true
            activityIndicator.isHidden = false
        case .isLoad:
            photoButton.isHidden = false
            activityIndicator.isHidden = true
        }
    }
    
}
