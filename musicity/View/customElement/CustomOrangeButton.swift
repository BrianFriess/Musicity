//
//  orangeButton.swift
//  musicity
//
//  Created by Brian Friess on 10/12/2021.
//

import UIKit

class CustomOrangeButton: UIButton {

   // @IBOutlet weak var orangeButton: UIButton!
    override func awakeFromNib() {
        configureButton()
    }
    
    private func configureButton(){
        layer.cornerRadius = 20
        layer.backgroundColor = UIColor.systemOrange.cgColor
    }
}
