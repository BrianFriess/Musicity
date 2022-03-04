//
//  ConnexionViewController.swift
//  musicity
//
//  Created by Brian Friess on 21/11/2021.
//

import UIKit

final class LogInViewController: UIViewController {
    
    private let alert = AlertManager()
    private let firebaseManager = FirebaseManager()
    private let geolocalisationManager = GeolocalisationManager()
    
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
    
    //when we click on the connexion button
    @IBAction func connexionButton(_ sender: UIButton) {
        customView.connexionIsLoadOrNot(.isOnLoad)
        //check if the password is not empty
        guard passwordTextField.text != "", let password = passwordTextField.text else {
            alert.alertVc(.emptyPassword, self)
            self.customView.connexionIsLoadOrNot(.isLoad)
            return
        }
        //check if email is not empty
        guard emailTextField.text != "", let email = emailTextField.text else {
            alert.alertVc(.emptyEmail, self)
            self.customView.connexionIsLoadOrNot(.isLoad)
            return
        }
        //connexion of the user
        firebaseManager.connexionUser(email, password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.performSegue(withIdentifier: SegueManager.goToMusicitySegue.returnSegueString, sender: self)
                self.customView.connexionIsLoadOrNot(.isLoad)
            case .failure(_):
                self.alert.alertVc(.errorConnexion, self)
                self.customView.connexionIsLoadOrNot(.isLoad)
            }
        }
    }
    
}


//MARK: KeyBoard Manager
extension LogInViewController : UITextFieldDelegate {
    
    //dismiss Keyboard when we click on the screen
    @IBAction func dismissKeyboard(_ sender: Any) {
        passwordTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
    }
    
    //dismiss keyboard when we click on "enter"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        passwordTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        return true
    }
    
}
