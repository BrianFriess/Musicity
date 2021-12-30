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
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCell()
    }
    
    
    func configureCell(){
       // scrollView.layer.cornerRadius = 10
        customView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7).cgColor
        customView.layer.shadowRadius = 2.0
        customView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        customView.layer.shadowOpacity = 2.0
        customView.layer.cornerRadius = 10


        //customView.layer.frame.size.height = screenSize.height
        //customView.layer.frame.size.width = screenSize.width
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
        scrollView.layer.cornerRadius = 10
        addSubview(scrollView)
        paddyY = createLabelInScrollView(infoInstrument, paddyY, scrollView)
        paddyY = createLabelInScrollView(infoStyle, paddyY, scrollView)
        scrollView.contentSize = CGSize(width: 0, height: paddyY)
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
    
    
    func configDistanceLabel(_ distance : String){
        distanceLabel.text = ("\(distance) Km")
    }
    
    
    
}

