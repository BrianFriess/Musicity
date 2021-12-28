//
//  ViewUserProfilViewController.swift
//  musicity
//
//  Created by Brian Friess on 06/12/2021.
//

import UIKit

class ResultUserProfilViewController: UIViewController {
    
    var currentUser = ResultInfo()
    @IBOutlet weak var profilPicture: UIImageView!
    @IBOutlet weak var userNameTextField: UILabel!
    @IBOutlet weak var bioTextField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    

    func configureView(){
        profilPicture.image = currentUser.profilPicture
        userNameTextField.text = currentUser.publicInfoUser[DataBaseAccessPath.username.returnAccessPath] as? String
    }

}


