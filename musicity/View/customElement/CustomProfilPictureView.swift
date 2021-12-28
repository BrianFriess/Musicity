//
//  CustomProfilPictureView.swift
//  musicity
//
//  Created by Brian Friess on 10/12/2021.
//

import UIKit

class CustomProfilPictureView: UIImageView {
    
    override func awakeFromNib() {
        configureProfilPicture()
    }
    
    private func configureProfilPicture(){
        layer.cornerRadius = 60
       // layer.borderWidth = 2
        //layer.borderColor = UIColor.white.cgColor
    }

}
