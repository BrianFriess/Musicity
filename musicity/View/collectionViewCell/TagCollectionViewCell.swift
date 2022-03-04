//
//  TagCollectionViewCell.swift
//  musicity
//
//  Created by Brian Friess on 07/12/2021.
//

import UIKit


final class TagCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var tagView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    //add color and corner radius at the "tag" in the page of the user
    private func configure() {
        tagView.layer.cornerRadius = 12.5
        tagView.layer.backgroundColor = UIColor.systemOrange.cgColor
    }
    
}
