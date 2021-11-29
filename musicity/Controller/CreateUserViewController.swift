//
//  ViewController.swift
//  musicity
//
//  Created by Brian Friess on 19/11/2021.
//

import UIKit
import Firebase

class CreateUserViewController: UIViewController {
    
    let alerte = AlerteManager()
    let firebaseManager = FirebaseManager()

    
    //MARK: Outlet
    @IBOutlet var customView: CustomCreateUserView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var SegmentedControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        customView.configureView()
    }

    
    //MARK: Action
    @IBAction func inscrireButton(_ sender: UIButton) {
        guard emailTextField.text != "", let emailUser = emailTextField.text  else{
            alerte.alerteVc(.EmptyEmail, self)
            return
        }
        
        guard passwordTextField.text != "", passwordTextField.text!.count >= 6, let passwordUser = passwordTextField.text else{
            alerte.alerteVc(.LessSixPassword, self)
            return
        }
        
        guard usernameTextField.text != "",  let username = usernameTextField.text else{
            alerte.alerteVc(.EmptyUsername, self)
            return
        }
        
        //create a new user
        firebaseManager.createNewUser(emailUser, passwordUser, username, SegmentedControl.selectedSegmentIndex) { result in
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
                                     self.performSegue(withIdentifier: "goToFirstConnexionSegue", sender: self)
                                 case.failure(_):
                                     self.alerte.alerteVc(.errorCreateUser, self)
                                 }
                             }
                        case .failure(_):
                            self.alerte.alerteVc(.errorCreateUser, self)
                        }
                    }
                case .failure(_):
                    self.alerte.alerteVc(.FalseEmail, self)
                }
            }
    }
    
    @IBAction func pushSegmentedControl(_ sender: UISegmentedControl) {
        customView.configureBandOrMusicien()
    }
    
}






//MARK: KeyBoard Manager
extension CreateUserViewController : UITextFieldDelegate{
    @IBAction func dismissKeyboard(_ sender: Any) {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        return true
    }
}
