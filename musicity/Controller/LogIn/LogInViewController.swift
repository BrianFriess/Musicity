//
//  ConnexionViewController.swift
//  musicity
//
//  Created by Brian Friess on 21/11/2021.
//

import UIKit


class LogInViewController: UIViewController {

    private let alerte = AlerteManager()
    private let firebaseManager = FirebaseManager()
    private let geolocalisationManager = GeolocalisationManager()

    
    //MARK: Outlet
    @IBOutlet var customView: CustomConnextionView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customView.configureView()
        AppUtility.lockOrientation(.portrait)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(true)
        //if the user Is disconnect, we remove The observer for the notification
        if UserInfo.shared.userID != "" {
            firebaseManager.removeNotificationObserver(UserInfo.shared.userID)
        }
        UserInfo.shared.resetSingleton()
    }
    
    
    //MARK: Action
    @IBAction func connexionButton(_ sender: UIButton) {
        customView.connexionIsLoadOrNot(.isOnLoad)
        //check if the password is not empty
        guard passwordTextField.text != "", let password = passwordTextField.text else{
            alerte.alerteVc(.emptyPassword, self)
            self.customView.connexionIsLoadOrNot(.isLoad)
            return
        }
        
        
        //check if email is not empty
        guard emailTextField.text != "", let email = emailTextField.text else{
            alerte.alerteVc(.EmptyEmail, self)
            self.customView.connexionIsLoadOrNot(.isLoad)
            return
        }
        
        //connexion of the user
        firebaseManager.connexionUser(email, password) { result in
            switch result{
            case .success(_):
                self.performSegue(withIdentifier: "GoToMusicitySegue", sender: self)
                self.customView.connexionIsLoadOrNot(.isLoad)
            case .failure(_):
                self.alerte.alerteVc(.ErrorConnexion, self)
                self.customView.connexionIsLoadOrNot(.isLoad)
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
