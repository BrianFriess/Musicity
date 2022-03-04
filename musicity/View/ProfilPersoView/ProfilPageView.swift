//
//  ProfilPage.swift
//  musicity
//
//  Created by Brian Friess on 06/12/2021.
//

import UIKit
import YoutubePlayer_in_WKWebView

final class ProfilPageView: UIView {

    @IBOutlet weak var profilPicture: UIImageView!
    @IBOutlet weak var usernameTextField: UILabel!
    @IBOutlet weak var nbMemberLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var bandOrMusicianLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var editActivityIndcator: UIActivityIndicatorView!
    @IBOutlet weak var youtubePlayer: WKYTPlayerView!
    @IBOutlet weak var bioLabelText: UITextView!
    
    enum BandOrMusician {
        case isBand
        case isMusician
    }
    
    //check if is a band or musician for display this
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
    
    //check if the informations is loading or not
    func loadSpinner(_ isLoading : IsLoading) {
        switch isLoading {
        case .isLoad:
            activityIndicator.isHidden = true
            profilPicture.isHidden = false
            editButton.isHidden = false
            editActivityIndcator.isHidden = true
        case .isInLoading:
            activityIndicator.isHidden = false
            profilPicture.isHidden = true
            editButton.isHidden = true
            editActivityIndcator.isHidden = false
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
