//
//  ConnexionViewController.swift
//  musicity
//
//  Created by Brian Friess on 21/11/2021.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {

    var alerte = AlerteManager()
    
    
    //MARK: Outlet
    @IBOutlet var testView: CustomConnextionView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testView.configureTextField()
        testView.configureButton()
    }
    

    //MARK: Action
    @IBAction func returnButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func connexionButton(_ sender: UIButton) {
        guard passwordTextField.text != "", let password = passwordTextField.text else{
            alerte.alerteVc(.emptyPassword, self)
            return
        }
        
        
        guard emailTextField.text != "", let email = emailTextField.text else{
            alerte.alerteVc(.EmptyEmail, self)
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if error != nil{
                self.alerte.alerteVc(.ErrorConnexion, self)
            }else{
                self.performSegue(withIdentifier: "goToHomeConnexion", sender: self)
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
