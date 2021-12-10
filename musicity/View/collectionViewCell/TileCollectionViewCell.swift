//
//  CollectionViewCell.swift
//  musicity
//
//  Created by Brian Friess on 03/12/2021.
//

import UIKit

class TileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var profilPicture: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCell()
        configureProfilPicture()
    }
    
    func configureCell(){
        customView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7).cgColor
        customView.layer.shadowRadius = 2.0
        customView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        customView.layer.shadowOpacity = 2.0
        customView.layer.cornerRadius = 10
    }
    
    func configureProfilPicture(){
        profilPicture.layer.cornerRadius = 60
        profilPicture.layer.borderWidth = 2
        profilPicture.layer.borderColor = UIColor.white.cgColor
    }
    
    
    
    
}
