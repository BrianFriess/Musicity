//
//  orangeButton.swift
//  musicity
//
//  Created by Brian Friess on 10/12/2021.
//

import UIKit

final class CustomOrangeButton: UIButton {
    
    override func awakeFromNib() {
        configureButton()
    }
    
    //add corner radius and color at UiButton
    private func configureButton() {
        layer.cornerRadius = 20
        layer.backgroundColor = UIColor.systemOrange.cgColor
    }
    
}
