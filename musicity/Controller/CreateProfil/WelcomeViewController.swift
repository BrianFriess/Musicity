//
//  WelcomeViewController.swift
//  musicity
//
//  Created by Brian Friess on 30/11/2021.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    private let firebaseManager = FirebaseManager()
    private let alerte = AlerteManager()
    
    
    //we get all the info to firebase 
    @IBAction func letsgoButton(_ sender: Any) {
        firebaseManager.getAllTheInfoToFirebase(UserInfo.shared.userID) { result in
            switch result{
            case .success(let allInfo):
                guard UserInfo.shared.addAllInfo(allInfo) else {
                    self.alerte.alerteVc(.errorGetInfo, self)
                    return
                }
                self.performSegue(withIdentifier: "GoToMusicityFromWelcome", sender: self)
            case .failure(_):
                self.alerte.alerteVc(.errorGetInfo, self)
            }
        }
    }

    
}
