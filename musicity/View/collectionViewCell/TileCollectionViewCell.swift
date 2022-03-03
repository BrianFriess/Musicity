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
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var rightArrow: UIImageView!
    @IBOutlet weak var leftArrow: UIImageView!
    @IBOutlet weak var bandOrMusicianLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCell()
    }
    
    //we check if the collectionView is the first or the last to display the arrow or not 
    func displayArrow(_ checkCollectionRow: Int, _ collectionMax : Int){
        if checkCollectionRow == 0 {
            leftArrow.isHidden = true
            rightArrow.isHidden = false
            if collectionMax - 1 == 0 {
                leftArrow.isHidden = true
                rightArrow.isHidden = true
            }
        } else if checkCollectionRow == collectionMax - 1 {
            rightArrow.isHidden = true
            leftArrow.isHidden = false
        } else {
            rightArrow.isHidden = false
            leftArrow.isHidden = false
        }
    }
    
    func configureCell(){
        customView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7).cgColor
        customView.layer.shadowRadius = 1.0
        customView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        customView.layer.shadowOpacity = 2.0
        customView.layer.cornerRadius = 25
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
    
    func createCustomView(){
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 350, height: 350))
        customView.backgroundColor = UIColor.red
        addSubview(customView)
    }
    
    
    //we create our scroll View
    func createScrollView(_ infoInstrument : [String], _ infoStyle : [String]){
        var paddyY = 0
        let scrollView = UIScrollView(frame: CGRect(x: customView.layer.frame.minX, y: customView.layer.frame.maxY/2+30, width: customView.layer.frame.size.width , height: customView.layer.frame.maxY/2-30))
        scrollView.backgroundColor = UIColor.systemOrange
        addSubview(scrollView)
        paddyY = createLabelInScrollView(infoInstrument, paddyY, scrollView)
        paddyY = createLabelInScrollView(infoStyle, paddyY, scrollView)
        scrollView.contentSize = CGSize(width: 0, height: paddyY)
        scrollView.layer.cornerRadius = 15
    }
    
    //we create the label View in the scrollView
    func createLabelInScrollView(_ infoArray: [String],_ posY : Int, _ scrollView : UIScrollView) -> Int{
        var paddyY = posY
        for info in infoArray{
            let label =  UILabel(frame: CGRect(x: 5, y:paddyY, width: Int(scrollView.layer.frame.size.width), height : 35))
            scrollView.addSubview(label)
            label.textColor = UIColor.white
            label.font = UIFont(name : "Arial Rounded MT Bold", size : 17)
            label.text = info
            paddyY += 30
        }
        return paddyY
    }
    
    func configureBandOrMusicianLabel(_ bandOrMusician : String){
        if bandOrMusician == "Band"{
            bandOrMusicianLabel.text = "Groupe"
        } else if bandOrMusician == "Musician" {
            bandOrMusicianLabel.text = "Musicien"
        } else {
            bandOrMusicianLabel.text = ""
        }
    }
    
    //we display the distance in the distance label
    func configDistanceLabel(_ distance : String){
        if distance != "" {
            distanceLabel.text = ("\(distance) Km")
        } else {
            distanceLabel.text = ""
        }
    }
}

