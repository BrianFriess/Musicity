//
//  CustomCreateSecondUIView.swift
//  musicity
//
//  Created by Brian Friess on 09/12/2021.
//

import UIKit

final class CustomCreateSecondUIView: UIView {
    
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var stackBand: UIStackView!
    @IBOutlet weak var labelBand: UILabel!
    
    func configView() {
        configureButton()
        configStepper()
    }
    
    private func configureButton() {
        photoButton.layer.cornerRadius = 60
        photoButton.layer.borderWidth = 2
        photoButton.layer.borderColor = UIColor.systemOrange.cgColor
        activityIndicator.isHidden = true
    }
    
    private func configStepper() {
        stepper.layer.cornerRadius = 8
    }

    enum BandOrMusician {
        case band
        case musician
    }
    
    //display the information in the stack view or not
    func customStack(_ bandOrMusician : BandOrMusician ) {
        switch bandOrMusician {
        case .band:
            stackBand.isHidden = false
            labelBand.isHidden = false
        case .musician:
            stackBand.isHidden = true
            labelBand.isHidden = true
        }
    }
    
    enum Loading {
        case isloading
        case isLoad
    }
    
    //check if the picture is load or not
    func loadPhoto(_ loadind : Loading) {
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
