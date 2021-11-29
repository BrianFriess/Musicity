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
        
        //verification du champs mot de passe
        guard passwordTextField.text != "", let password = passwordTextField.text else{
            alerte.alerteVc(.emptyPassword, self)
            return
        }
        
        //verification du champs email
        guard emailTextField.text != "", let email = emailTextField.text else{
            alerte.alerteVc(.EmptyEmail, self)
            return
        }
        
        firebaseManager.connexionUser(email, password) { result in
            switch result{
            case .success(_):
                //we recover the userID in the singleton 
                self.firebaseManager.getUserId { result in
                    switch result{
                    case .success(let userId):
                        UserInfo.shared.addUserId(userId)
                        //we recover the public Info in the singleton
                        self.firebaseManager.getDictionnaryInfoUserToFirebase( UserInfo.shared.userID, .publicInfoUser) { result in
                             switch result{
                             case .success(let infoUser):
                                 UserInfo.shared.addPublicInfo(infoUser)
                                 self.performSegue(withIdentifier: "goToHomeConnexion", sender: self)
                             case.failure(_):
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
