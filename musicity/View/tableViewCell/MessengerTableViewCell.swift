//
//  MessengerTableViewCell.swift
//  musicity
//
//  Created by Brian Friess on 04/01/2022.
//

import UIKit

final class MessengerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //we add a cornerRadius as the picture
    private func configure() {
        picture.layer.cornerRadius = 38.5
    }
    
    enum PictureIsLoad {
        case isLoad
        case isNotLoad
    }
    
    //when we call this function, we set isLoad for display the activity indicator or not
    func loadingPicture( _ isLoad : PictureIsLoad) {
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
