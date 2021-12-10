//
//  ProfilPage.swift
//  musicity
//
//  Created by Brian Friess on 06/12/2021.
//

import UIKit

class ProfilPageView: UIView {

    @IBOutlet weak var profilPicture: UIImageView!
    @IBOutlet weak var usernameTextField: UILabel!
    @IBOutlet weak var nbMemberLabel: UILabel!
    @IBOutlet weak var bandOrMusicianLabel: UILabel!
    
    
    func configure(){
        configureProfilPicture()
    }
    
    private func configureProfilPicture(){
        profilPicture.layer.cornerRadius = 60
        profilPicture.layer.borderWidth = 2
        profilPicture.layer.borderColor = UIColor.white.cgColor
    }
    
    enum BandOrMusician{
        case isBand
        case isMusician
    }
    
    func isBandOrMusician(_ style : BandOrMusician){
        switch style {
        case .isBand:
            nbMemberLabel.isHidden = false
            bandOrMusicianLabel.text = "Groupe"
        case .isMusician:
            nbMemberLabel.isHidden = true
            bandOrMusicianLabel.text = "Musicien"
        }
    }
    
    
}
