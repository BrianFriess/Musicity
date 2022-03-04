//
//  ResultProfilPage.swift
//  musicity
//
//  Created by Brian Friess on 28/12/2021.
//

import UIKit
import YoutubePlayer_in_WKWebView

final class ResultProfilPage: UIView {

    @IBOutlet weak var profilPicture: UIImageView!
    @IBOutlet weak var nbMemberLabel: UILabel!
    @IBOutlet weak var bandOrMusicianLabel: UILabel!
    @IBOutlet weak var usernameTextField: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var youtubePlayer: WKYTPlayerView!
    @IBOutlet weak var bioLabelText: UITextView!
    
    enum BandOrMusician {
        case isBand
        case isMusician
    }
    
    //configure name label
    func configLabelUsername(_ username : String) {
        usernameTextField.text = username
    }
    
    //check if it's a band or musician
    func isBandOrMusician(_ style : BandOrMusician) {
        switch style {
        case .isBand:
            nbMemberLabel.isHidden = false
            bandOrMusicianLabel.text = "Groupe"
        case .isMusician:
            nbMemberLabel.isHidden = true
            bandOrMusicianLabel.text = "Musicien"
        }
    }
    
    enum IsLoading {
        case isLoad
        case isInLoading
    }
    
    //check if the information is load or not
    func loadSpinner(_ isLoading : IsLoading) {
        switch isLoading {
        case .isLoad:
            activityIndicator.isHidden = true
            profilPicture.isHidden = false
        case .isInLoading:
            activityIndicator.isHidden = false
            profilPicture.isHidden = true
        }
    }
    
    enum IsEmpty {
        case isEmpty
        case isNotEmpty
    }
    
    //check if the bio is empty or not
    func bioIsEmpty(_ checkBio : IsEmpty) {
        switch checkBio {
        case .isEmpty:
            bioLabelText.text = "Pas de bio pour l'instant..."
        case .isNotEmpty:
            break
        }
    }
    
    //check if we have a youtube video or not
    func youtubePlayerIsEmpty(_ checkYoutubeUrl : IsEmpty) {
        switch checkYoutubeUrl {
        case .isEmpty:
            youtubePlayer.isHidden = true
        case .isNotEmpty:
            youtubePlayer.isHidden = false
        }
    }
    
}
