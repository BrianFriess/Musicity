//
//  TagCollectionViewCell.swift
//  musicity
//
//  Created by Brian Friess on 07/12/2021.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var tagView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    func configure(){
        tagView.layer.cornerRadius = 12.5
        tagView.layer.backgroundColor = UIColor.systemOrange.cgColor
    }
    

    
    
    

}
