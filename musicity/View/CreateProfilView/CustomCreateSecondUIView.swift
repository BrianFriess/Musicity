//
//  CustomCreateSecondUIView.swift
//  musicity
//
//  Created by Brian Friess on 09/12/2021.
//

import UIKit

class CustomCreateSecondUIView: UIView {
    
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var stackBand: UIStackView!
    @IBOutlet weak var labelBand: UILabel!
    
    func configView(){
        configureButton()
        configStepper()
    }
    
    func configureButton(){
        photoButton.layer.cornerRadius = 60
        photoButton.layer.borderWidth = 2
        photoButton.layer.borderColor = UIColor.systemOrange.cgColor
        activityIndicator.isHidden = true
    }
    
    func configStepper(){
        stepper.layer.cornerRadius = 8
    }

    enum BandOrMusician{
        case band
        case musician
    }
    
    func customStack(_ bandOrMusician : BandOrMusician ){
        switch bandOrMusician {
        case .band:
            stackBand.isHidden = false
            labelBand.isHidden = false
        case .musician:
            stackBand.isHidden = true
            labelBand.isHidden = true
        }
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
