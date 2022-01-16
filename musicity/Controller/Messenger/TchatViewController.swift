//
//  TchatViewController.swift
//  musicity
//
//  Created by Brian Friess on 05/01/2022.
//

import UIKit

class TchatViewController: UIViewController {


    @IBOutlet weak var upView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sentButton: UIButton!
    
    var firebaseManager = FirebaseManager()
    var currentUser = ResultInfo()
    var messages = [[String:Any]]()
    var alerte = AlerteManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firebaseManager.readInMessengerDataBase(UserInfo.shared.userID, currentUser.userID) { result in
            switch result{
            case .success(let messages):
                self.messages.append(messages)
                self.tableView.insertRows(at: [IndexPath(row: self.messages.count-1, section: 0)], with: .automatic)
            case .failure(_):
                break
            }
        }
    }



    
    //before set the id of the user in our DDB, we check if he already exists
    private func checkIfUserAlreadyHere(_ user : ResultInfo) -> Bool{
        for currentUserId in UserInfo.shared.activeMessengerUserIdFirebase{
            if currentUserId == user.userID{
                return true
            }
        }
        return false
    }
    
    
    
    //push send button
    @IBAction func sendButton(_ sender: Any) {
        //we create a new message
        if textField.text != ""{
            
            let newMessage : [String:Any] = [
                "name" : UserInfo.shared.publicInfoUser[DataBaseAccessPath.username.returnAccessPath]!,
                "message" : textField.text!
            ]
            //we send the new message in our DDB
            firebaseManager.setNewMessage(UserInfo.shared.userID, currentUser.userID, newMessage) { [self] result in
                switch result{
                case .success(_):
                    self.textField.resignFirstResponder()

                    self.textField.text = ""
                    addNewUserIdInUserListMessenger()
                case .failure(_):
                   // alerte.alerteVc(.messageError, self)
                    print("fail")
                }
            }
        }
    }
    
    
    //if the userId is not in our DDB, we create a new value in our DDB and we recover this value in our array of UserIdMessenger
    private func addNewUserIdInUserListMessenger(){
        if !self.checkIfUserAlreadyHere(currentUser){
            let countUserIdMessenger = UserInfo.shared.activeMessengerUserIdFirebase.count
            //we set our value in a dictionnary for set the DDB
            UserInfo.shared.activeMessengerUserId[String(countUserIdMessenger)] =  self.currentUser.userID
            //we add the new id in our DDB
            firebaseManager.setTheUserIdMessengerInDdb(UserInfo.shared.userID, UserInfo.shared.activeMessengerUserId) { result in
                switch result{
                case .success(_):
                    //we recover the new id in our Array in local
                    self.firebaseManager.getTheUserIdMessengerToDdb(UserInfo.shared.userID) { result in
                        switch result{
                        case .success(let userIdArray):
                            self.addNewUserInTheOtherUserListMessenger()
                            UserInfo.shared.addAllUserMessenger(userIdArray)
                        case .failure(_):
                            self.alerte.alerteVc(.messageError, self)
                        }
                    }
                case .failure(_):
                    self.alerte.alerteVc(.messageError, self)
                }
            }
        }
    }
    
    
    //if we add the userId in the lise of messenger active in the UserInfo, we need to do the same thing in the currentUserResult
    private func addNewUserInTheOtherUserListMessenger(){
        //we get all the user in the messenger Id
        firebaseManager.getTheUserIdMessengerToDdb(currentUser.userID) { result in
            switch result{
            case .success(let arrayUser):
                print(arrayUser)
                //we create an array of user Id
                var arrayUserAndCurrentUserInfo = arrayUser
                arrayUserAndCurrentUserInfo.append(UserInfo.shared.userID)
                //we send the array for transform this in  dictionnary for firebase
                self.currentUser.addAllUserMessenger(arrayUserAndCurrentUserInfo)
                //we set the new dictionnaty in firebase
                self.firebaseManager.setTheUserIdMessengerInDdb(self.currentUser.userID, self.currentUser.activeMessengerUserId) { result  in
            switch result{
                case .success(_):
                break
            case .failure(_):
                self.alerte.alerteVc(.messageError, self)
            }
        }
                //if we don't have a userMessengerId in our database, we create an dictionnary just with the UserInfo
            case .failure(_):
                self.currentUser.addAllUserMessenger([UserInfo.shared.userID])
                //we set the dictionnary in our database
                self.firebaseManager.setTheUserIdMessengerInDdb(self.currentUser.userID, self.currentUser.activeMessengerUserId) { result  in
                    switch result{
                        case .success(_):
                        break
                    case .failure(_):
                        self.alerte.alerteVc(.messageError, self)
                    }
                }
            }
        }
    }
    
    
    
}


extension TchatViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellTchat", for : indexPath) as? TchatTableViewCell else {
            return UITableViewCell()
        }

        cell.messageLabel.text = messages[indexPath.row]["message"] as? String
        cell.nameLabel.text = messages[indexPath.row]["name"] as? String
        if cell.nameLabel.text == UserInfo.shared.publicInfoUser[DataBaseAccessPath.username.returnAccessPath] as? String{
            cell.viewCustom.backgroundColor = UIColor.systemOrange
        } else {
            cell.viewCustom.backgroundColor = UIColor.gray
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    
    
}


//extension for the keyboard

extension TchatViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textField.resignFirstResponder()
        return true
    }
    
}
