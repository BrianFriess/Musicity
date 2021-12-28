//
//  EditProfilCustomView.swift
//  musicity
//
//  Created by Brian Friess on 20/12/2021.
//

import UIKit


class EditProfilCustomView: UIView {


    @IBOutlet weak var activityIndicatorPP: UIActivityIndicatorView!
    @IBOutlet weak var profilPicture: UIButton!
    @IBOutlet weak var bioLabelText: UITextView!
    @IBOutlet weak var saveActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var youtubeUrlLabel: UITextField!
    
    func configure(_ profilPicture : UIImage) {
        configureButton(profilPicture)
    }
    
    enum Loading{
        case isloading
        case isLoad
    }
    
    
    func loadPhoto(_ loadind : Loading){
        switch loadind {
        case .isloading:
            profilPicture.isHidden = true
            activityIndicatorPP.isHidden = false
            saveButton.isHidden = true
            saveActivityIndicator.isHidden = false
        case .isLoad:
            profilPicture.isHidden = false
            activityIndicatorPP.isHidden = true
            saveButton.isHidden = false
            saveActivityIndicator.isHidden = true
        }
    }
    
    
    private func configureButton(_ profilPictureUser : UIImage){
        profilPicture.layer.cornerRadius = 60
        profilPicture.setImage(profilPictureUser, for: .normal)
        profilPicture.imageView?.contentMode = .scaleAspectFill
        profilPicture.clipsToBounds = true
    }
    
    enum IsEmpty{
        case isEmpty
        case isNotEmpty
    }
    
    func bioIsEmpty(_ checkBio : IsEmpty){
        switch checkBio {
        case .isEmpty:
            bioLabelText.text = "Pas de bio pour l'instant..."
        case .isNotEmpty:
            break
        }
    }
    


}
