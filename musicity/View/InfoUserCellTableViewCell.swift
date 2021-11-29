//
//  CustomCellCreationProfilTableViewCell.swift
//  musicity
//
//  Created by Brian Friess on 27/11/2021.
//

import UIKit

class InfoUserCellTableViewCell: UITableViewCell {

    @IBOutlet weak var whiteView: UIView!

    @IBOutlet weak var labelTextInstrument: UILabel!
    @IBOutlet weak var blueView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addShadow()
        labelTextInstrument.text = "test"
    }

    private func addShadow() {
        whiteView.layer.cornerRadius = 5
        blueView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7).cgColor
        blueView.layer.shadowRadius = 2.0
        blueView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        blueView.layer.shadowOpacity = 2.0
        blueView.layer.cornerRadius = 5
    }

}
