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
        
        //tagLabel.layer.shadowRadius = 2.0
        //tagLabel.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7).cgColor
        //tagLabel.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        //tagLabel.layer.shadowOpacity = 2.0
    }
    
    private func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
    
    private var randomColor : CGColor {
        return CGColor(red:   .random(in : 0...1),
                       green: .random(in : 0...1),
                       blue:  .random(in : 0...1),
                       alpha: 1.0)
    }
    
    

}
