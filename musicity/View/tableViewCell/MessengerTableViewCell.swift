//
//  MessengerTableViewCell.swift
//  musicity
//
//  Created by Brian Friess on 04/01/2022.
//

import UIKit

class MessengerTableViewCell: UITableViewCell {

    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    enum PictureIsLoad{
        case isLoad
        case isNotLoad
    }
    
    func configure(){
        picture.layer.cornerRadius = 38.5
    }
    
    func loadingPicture( _ isLoad : PictureIsLoad){
        switch isLoad {
        case .isLoad:
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            picture.isHidden = false
        case .isNotLoad:
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            picture.isHidden = true

        }
    }

}
