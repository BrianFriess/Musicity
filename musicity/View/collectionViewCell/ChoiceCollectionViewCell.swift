//
//  StyleCollectionViewCell.swift
//  musicity
//
//  Created by Brian Friess on 08/12/2021.
//

import UIKit
import SwiftUI

class ChoiceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var tagView: UIView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    
    func configure(){
        tagView.layer.cornerRadius = 12
        tagView.layer.backgroundColor = UIColor.black.cgColor
        tagView.layer.borderWidth = 1
        tagView.layer.borderColor = UIColor.systemOrange.cgColor
    }

    

    func selectCell(_ isSelect : Bool){
        if isSelect == false{
            tagView.layer.backgroundColor = UIColor.white.cgColor
            tagLabel.textColor = #colorLiteral(red: 0.08961678296, green: 0.1305745542, blue: 0.1723892391, alpha: 1)
        } else {
            tagView.layer.backgroundColor = UIColor.systemOrange.cgColor
            tagLabel.textColor = UIColor.white
        }
    }

    
}
