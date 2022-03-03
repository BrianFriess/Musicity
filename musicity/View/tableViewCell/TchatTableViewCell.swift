//
//  TchatTableViewCell.swift
//  musicity
//
//  Created by Brian Friess on 05/01/2022.
//

import UIKit
import SwiftUI

class TchatTableViewCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var viewCustom: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    func configure(){
        viewCustom.layer.cornerRadius = 10
    }
}
