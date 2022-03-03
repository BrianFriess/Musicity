//
//  MessengerViewController.swift
//  musicity
//
//  Created by Brian Friess on 04/01/2022.
//

import UIKit

class AllConversation: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let firebaseManager = FirebaseManager()
    private let alert = AlertManager()
    
    var arrayUserMessenger = [ResultInfo]()
    var row = 0
    
    override func viewDidAppear(_ animated: Bool) {
        checkIfWeHaveAMessengerUser()
        addObserverNotification()
        self.tableView.reloadData()
    }
    
    //we check if we have an user Id before read all the user id
    private func checkIfWeHaveAMessengerUser(){
        //if we have already a active messenger user in firebase we check for get the name and the profil picture in another function
        if arrayUserMessenger.count != UserInfo.shared.activeMessengerUserIdFirebase.count{
            if UserInfo.shared.activeMessengerUserIdFirebase.count != 0{
                arrayUserMessenger = []
                checkMessengerUserId()
            }
        }
    }
    
    //we check all the userID who we have already a conversation
    private func checkMessengerUserId(){
        for i in 0...UserInfo.shared.activeMessengerUserIdFirebase.count-1{
            let currentUser = ResultInfo()
            firebaseManager.getAllTheInfoToFirebase(UserInfo.shared.activeMessengerUserIdFirebase[i]) { result in
                switch result{
                case .success(let user):
                    //we get a userId and the user information in an array for our table View
                    currentUser.addAllInfo(user)
                    currentUser.addUserId(UserInfo.shared.activeMessengerUserIdFirebase[i])
                    //we add the new user in our array
                    self.addUserInArrayForTableView(currentUser)
                case .failure(_):
                    break
                }
            }
        }
    }
    
    private func addUserInArrayForTableView(_ currentUser : ResultInfo){
        if !self.checkIfUserAlreadyHere(currentUser, self.arrayUserMessenger){
            self.arrayUserMessenger.append(currentUser)
            addObserverNotification()
        }
    }
    
    //before set the id of the user in our array, we check if he already exists in the array
    private func checkIfUserAlreadyHere(_ user : ResultInfo, _ arrayUser : [ResultInfo]) -> Bool{
        for currentUserId in arrayUser{
            if currentUserId.userID == user.userID{
                return true
            }
        }
        return false
    }
    
    //we add an observer for look if we have a notification user in our ddb for display this user in first in our ddb
    func addObserverNotification(){
        firebaseManager.checkNewUserNotification(UserInfo.shared.userID) { result in
            switch result{
            case .success(let userIdNotification):
                if self.arrayUserMessenger.count != 0{
                    self.checkIfHaveANotificationUser(userIdNotification[DataBaseAccessPath.notification.returnAccessPath] as! String)
                }
            case .failure(_):
                self.tableView.reloadData()
            }
        }
    }
    
    //if we have a new user in our notification, we change the place of the user in our array
    func checkIfHaveANotificationUser(_ userId : String){
        for i in 0...arrayUserMessenger.count-1{
            if userId == arrayUserMessenger[i].userID{
                let tampUser = arrayUserMessenger[i]
                arrayUserMessenger.remove(at: i)
                arrayUserMessenger.insert(tampUser, at: 0)
                arrayUserMessenger[0].haveNotification = true
                tableView.reloadData()
            }
        }
    }
}


extension AllConversation : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayUserMessenger.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "messengerCell", for : indexPath) as? MessengerTableViewCell else {
            return UITableViewCell()
        }
        
        if arrayUserMessenger[indexPath.row].haveNotification == true {
            cell.nameLabel.font = .boldSystemFont(ofSize: 22)
            cell.nameLabel.textColor = .darkText
        } else {
            cell.nameLabel.font = .systemFont(ofSize: 20)
            cell.nameLabel.textColor = .systemOrange
        }
        cell.nameLabel.text = arrayUserMessenger[indexPath.row].publicInfoUser[DataBaseAccessPath.username.returnAccessPath] as? String
        if arrayUserMessenger[indexPath.row].profilPicture == nil{
            cell.loadingPicture(.isNotLoad)
        } else {
            cell.picture.image = arrayUserMessenger[indexPath.row].profilPicture
            cell.loadingPicture(.isLoad)
        }
        return cell
    }
    
    //we prepare our userId in the segue for load the conversation with the right user
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueManager.segueToMessenger.returnSegueString{
            let successVC = segue.destination as! TchatViewController
            successVC.currentUser = arrayUserMessenger[row]
        }
    }
    
    //when we click on a cell, we delete the notification in the DDB
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        row = indexPath.row
        performSegue(withIdentifier: SegueManager.segueToMessenger.returnSegueString, sender: self)
        firebaseManager.removeNotificationUser(UserInfo.shared.userID, arrayUserMessenger[indexPath.row].userID)
        arrayUserMessenger[indexPath.row].haveNotification = false
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //cache for load the profil picture 
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.arrayUserMessenger[indexPath.row].profilPicture == nil {
            self.firebaseManager.getUrlImageToFirebase(arrayUserMessenger[indexPath.row].userID) { resultUrl in
                switch resultUrl{
                case .success(let url):
                    self.arrayUserMessenger[indexPath.row].addUrlString(url)
                    self.firebaseManager.getImageToFirebase(self.arrayUserMessenger[indexPath.row].stringUrl) { result in
                            switch result{
                            case .success(let image):
                                self.arrayUserMessenger[indexPath.row].addProfilPicture(image)
                                self.tableView.reloadData()
                            case .failure(_):
                                self.alert.alertVc(.errorCheckAroundUs, self)
                            }
                        }
                case .failure(_):
                    self.alert.alertVc(.errorCheckAroundUs, self)
                }
            }
        }
    }
}


