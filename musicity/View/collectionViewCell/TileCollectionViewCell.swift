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
    @IBOutlet weak var spinnerActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCell()
    }
    
    
    func configureCell(){
        customView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7).cgColor
        customView.layer.shadowRadius = 2.0
        customView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        customView.layer.shadowOpacity = 2.0
        customView.layer.cornerRadius = 10
    }
    
    enum IsLoading{
        case isLoad
        case isInLoading
    }
    
    //the view display the spinner or the profil picture
    func loadPhoto(_ isLoading : IsLoading, _ profilPicture : UIImage?){
        switch isLoading {
        case .isLoad:
            spinnerActivityIndicator.isHidden = true
            spinnerActivityIndicator.stopAnimating()
            self.profilPicture.isHidden = false
            self.profilPicture.image = profilPicture
        case .isInLoading:
            spinnerActivityIndicator.isHidden = false
            spinnerActivityIndicator.startAnimating()
            self.profilPicture.isHidden = true
        }
    }
    
    
    
    
}
