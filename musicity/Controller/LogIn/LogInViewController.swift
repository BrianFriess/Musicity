//
//  ConnexionViewController.swift
//  musicity
//
//  Created by Brian Friess on 21/11/2021.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {

    var alerte = AlerteManager()
    var firebaseManager = FirebaseManager()
    
    //MARK: Outlet
    @IBOutlet var testView: CustomConnextionView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testView.configureView()
    }
    

    //MARK: Action
    @IBAction func connexionButton(_ sender: UIButton) {
        
        //check if the password is not empty
        guard passwordTextField.text != "", let password = passwordTextField.text else{
            alerte.alerteVc(.emptyPassword, self)
            return
        }
        
        //check if email is not empty
        guard emailTextField.text != "", let email = emailTextField.text else{
            alerte.alerteVc(.EmptyEmail, self)
            return
        }
        
        //connexion of the user
        firebaseManager.connexionUser(email, password) { result in
            switch result{
            case .success(_):
                //we get the userID
                self.firebaseManager.getUserId { result in
                    switch result{
                    case .success(let userId):
                        UserInfo.shared.addUserId(userId)
                        //we read all the information in the DDB
                        self.firebaseManager.getAllTheInfoToFirebase(userId) { result in
                            switch result{
                            case .success(let allInfo):
                                //if we have all the information, we get the information in the singleton
                                let allInfoIsGet = UserInfo.shared.addAllInfo(allInfo)
                                if allInfoIsGet {
                                    //get the url profil picture
                                    self.firebaseManager.getUrlImageToFirebase(userId) { resultImage in
                                        switch resultImage{
                                        case .success(let imageUrl):
                                            //get the profil Picture url in the singleton and go to the next page
                                            UserInfo.shared.addUrlString(imageUrl)
                                            self.performSegue(withIdentifier: "GoToMusicitySegue", sender: self)
                                        case .failure(_):
                                            self.alerte.alerteVc(.errorGetInfo, self)
                                        }
                                    }
                                } else {
                                    self.logInButMissInformation()
                                }
                            case .failure(_):
                                self.alerte.alerteVc(.errorGetInfo, self)
                            }
                        }
                    case .failure(_):
                        self.alerte.alerteVc(.errorGetInfo, self)
                    }
                }
            case .failure(_):
                self.alerte.alerteVc(.ErrorConnexion, self)
            }
        }
    }
    
    
    func logInButMissInformation(){
        //we go to the viewController for enter all the informations
        self.performSegue(withIdentifier: "goToHomeConnexion", sender: self)
    }
    
}

//MARK: KeyBoard Manager
extension LogInViewController : UITextFieldDelegate{
    @IBAction func dismissKeyboard(_ sender: Any) {
        passwordTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        passwordTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        return true
    }
}
