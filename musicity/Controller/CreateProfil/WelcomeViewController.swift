//
//  WelcomeViewController.swift
//  musicity
//
//  Created by Brian Friess on 30/11/2021.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    private let firebaseManager = FirebaseManager()
    private let alert = AlertManager()
    
    //we get all the info in the singleton
    @IBAction func letsgoButton(_ sender: Any) {
        firebaseManager.getAllTheInfoToFirebase(UserInfo.shared.userID) { result in
            switch result{
            case .success(let allInfo):
                guard UserInfo.shared.addAllInfo(allInfo) else {
                    self.alert.alertVc(.errorGetInfo, self)
                    return
                }
                self.performSegue(withIdentifier: SegueManager.goToMusicityFromWelcome.returnSegueString, sender: self)
            case .failure(_):
                self.alert.alertVc(.errorGetInfo, self)
            }
        }
    }
}
