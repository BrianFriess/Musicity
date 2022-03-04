//
//  TchatTableViewCell.swift
//  musicity
//
//  Created by Brian Friess on 05/01/2022.
//

import UIKit
import SwiftUI

final class TchatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var viewCustom: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    //we add a corner radius at the view with the text field in the tchat view controller
    private func configure() {
        viewCustom.layer.cornerRadius = 10
    }

}
