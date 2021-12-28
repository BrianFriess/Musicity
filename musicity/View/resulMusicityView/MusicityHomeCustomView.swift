//
//  ViewController.swift
//  musicity
//
//  Created by Brian Friess on 02/12/2021.
//

import UIKit

class MusicityHomeCustomView: UIView {
// custom pour afficher le label si geoloc pas activé

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var labelTextGeolocalisation: UILabel!

    
    
    enum GeolocalisationIsActive{
        case isActive
        case notActive
    }
    
    func displayLabelGeolocalisation(_ geolocalisation : GeolocalisationIsActive){
        switch geolocalisation {
        case .isActive:
            labelTextGeolocalisation.isHidden = true
            collectionView.isHidden = false
        case .notActive:
            labelTextGeolocalisation.isHidden = false
            collectionView.isHidden = true
        }
    }
    
}
