//
//  ViewUserProfilViewController.swift
//  musicity
//
//  Created by Brian Friess on 06/12/2021.
//

import UIKit

class ViewUserProfilViewController: UIViewController {
    
    var currentUser = ResultInfo()
    @IBOutlet weak var profilPicture: UIImageView!
    @IBOutlet weak var userNameTextField: UILabel!
    @IBOutlet weak var bioTextField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureProfilPicture()
        configureView()
    }
    

    func configureView(){
        profilPicture.image = currentUser.profilPicture
        userNameTextField.text = currentUser.publicInfoUser[DataBaseAccessPath.username.returnAccessPath] as? String
    }
    
    func configureProfilPicture(){
        profilPicture.layer.cornerRadius = 60
        profilPicture.layer.borderWidth = 2
        profilPicture.layer.borderColor = UIColor.white.cgColor
    }
    
    
    

}
