//
//  ViewController.swift
//  musicity
//
//  Created by Brian Friess on 19/11/2021.
//

import UIKit


class CreateUserViewController: UIViewController {
    
    private let alert = AlertManager()
    private let firebaseManager = FirebaseManager()

    @IBOutlet var customView: CustomCreateUserView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        customView.configureView()
    }

    @IBAction func inscriptionButton(_ sender: UIButton) {
        customView.connexionIsLoadOrNot(.isOnLoad)
        
        //we check if the 3 textField is empty or not
        guard emailTextField.text != "", let emailUser = emailTextField.text  else {
            alert.alertVc(.EmptyEmail, self)
            customView.connexionIsLoadOrNot(.isLoad)
            return
        }
        
        guard passwordTextField.text != "", passwordTextField.text!.count >= 6, let passwordUser = passwordTextField.text else {
            alert.alertVc(.LessSixPassword, self)
            customView.connexionIsLoadOrNot(.isLoad)
            return
        }
        
        guard usernameTextField.text != "",  let username = usernameTextField.text else {
            alert.alertVc(.EmptyUsername, self)
            customView.connexionIsLoadOrNot(.isLoad)
            return
        }
        //create a new user
        firebaseManager.createNewUser(emailUser, passwordUser, username, segmentedControl.selectedSegmentIndex) { result in
            switch result{
            case .success(_):
                //we recover the userID in the singleton
                self.firebaseManager.getUserId { result in
                    switch result{
                    case .success(let userId):
                        UserInfo.shared.addUserId(userId)
                        //we recover all the info of the user to ddb
                        self.getAllTheUserInfoToDDB()
                    case .failure(_):
                        self.alert.alertVc(.errorCreateUser, self)
                        self.customView.connexionIsLoadOrNot(.isLoad)
                    }
                }
            case .failure(_):
                self.alert.alertVc(.FalseEmail, self)
                self.customView.connexionIsLoadOrNot(.isLoad)
            }
        }
    }
    
    @IBAction func pushSegmentedControl(_ sender: UISegmentedControl) {
        customView.configureBandOrMusicien()
    }
    
    func getAllTheUserInfoToDDB(){
        self.firebaseManager.getDictionnaryInfoUserToFirebase(UserInfo.shared.userID, .publicInfoUser) { result in
             switch result{
             case .success(let infoUser):
                 //we recover the public Info in the singleton
                 self.addAllInfoOfUserInTheSingletonAndGoToTheSegue(infoUser)
             case.failure(_):
                 self.alert.alertVc(.errorCreateUser, self)
                 self.customView.connexionIsLoadOrNot(.isLoad)
             }
         }
    }
    
    //we recover the public Info in the singleton
    func addAllInfoOfUserInTheSingletonAndGoToTheSegue(_ infoUser : [String :Any]){
        UserInfo.shared.addPublicInfo(infoUser)
        performSegue(withIdentifier: SegueManager.goToFirstConnexionSegue.returnSegueString, sender: self)
        customView.connexionIsLoadOrNot(.isLoad)
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
