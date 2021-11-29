//
//  ViewController.swift
//  musicity
//
//  Created by Brian Friess on 19/11/2021.
//

import UIKit
import Firebase
import FirebaseDatabase


class CreateUserViewController: UIViewController {
    
    let alerte = AlerteManager()
    
    
    //MARK: Outlet
    @IBOutlet var customView: CustomCreateLogInView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    
    override func viewDidLoad() {
        customView.configureTextField()
        customView.configureButton()
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
        
        //creation d'un nouvel utilisateur
        Auth.auth().createUser(withEmail: emailUser, password: passwordUser){ authResult, error in
            if error != nil{
                print(error.debugDescription)
                self.alerte.alerteVc(.FalseEmail, self)
            }else{
                
                //creation dans la base de données firebase du nom d'utilisateur à l'IDUser
               let ref = Database.database(url: "https://musicity-ff6d8-default-rtdb.europe-west1.firebasedatabase.app").reference()
                let userID = Auth.auth().currentUser?.uid
                ref.child("users").child(userID!).setValue(["username" : username])

                self.performSegue(withIdentifier: "goToHomeSegue", sender: self)
            }
        }
    }
    
    @IBAction func connexionButton(_ sender: UIButton) {
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
