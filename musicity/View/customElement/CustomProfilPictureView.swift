//
//  CustomProfilPictureView.swift
//  musicity
//
//  Created by Brian Friess on 10/12/2021.
//

import UIKit

final class CustomProfilPictureView: UIImageView {
    
    override func awakeFromNib() {
        configureProfilPicture()
    }
    
    //add corner radius at the UIImageView
    private func configureProfilPicture() {
        layer.cornerRadius = 60
    }
    
}
