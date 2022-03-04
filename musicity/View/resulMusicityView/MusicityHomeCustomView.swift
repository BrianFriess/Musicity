//
//  ViewController.swift
//  musicity
//
//  Created by Brian Friess on 02/12/2021.
//

import UIKit

final class MusicityHomeCustomView: UIView {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var labelTextGeolocalisation: UILabel!

    enum GeolocalisationIsActive {
        case isActive
        case notActive
    }
    
    //check is the geolocalisation is acticate or not for display the collection View or not
    func displayLabelGeolocalisation(_ geolocalisation : GeolocalisationIsActive) {
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
