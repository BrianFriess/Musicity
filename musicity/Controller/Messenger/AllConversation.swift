//
//  MessengerViewController.swift
//  musicity
//
//  Created by Brian Friess on 04/01/2022.
//

import UIKit

class AllConversation: UIViewController {
    
    private let firebaseManager = FirebaseManager()
    private let alerte = AlerteManager()
    private let ref = FirebaseReference.ref
    private let storage = FirebaseReference.storage
    
    var arrayUserMessenger = [ResultInfo]()
    var row = 0


    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkIfWeHaveAMessengerUser()
    }
    
    //we check if we have an user Id before read all the user id
    private func checkIfWeHaveAMessengerUser(){
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
            firebaseManager.getAllTheInfoToFirebase(ref, UserInfo.shared.activeMessengerUserIdFirebase[i]) { result in
                switch result{
                case .success(let user):
                    //we get a userId and the user information in an array for our table View
                    currentUser.addAllInfo(user)
                    currentUser.addUserId(UserInfo.shared.activeMessengerUserIdFirebase[i])
                    self.arrayUserMessenger.append(currentUser)
                    self.tableView.reloadData()
                case .failure(_):
                    print("fail")
                }
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
        if segue.identifier == "segueToMessenger"{
            let successVC = segue.destination as! TchatViewController
            successVC.currentUser = arrayUserMessenger[row]
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        row = indexPath.row
        performSegue(withIdentifier: "segueToMessenger", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    

    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        
        if self.arrayUserMessenger[indexPath.row].profilPicture == nil {
        self.firebaseManager.getUrlImageToFirebase(storage, arrayUserMessenger[indexPath.row].userID) { resultUrl in
            switch resultUrl{
            case .success(let url):
                self.arrayUserMessenger[indexPath.row].addUrlString(url)
                self.firebaseManager.getImageToFirebase(self.storage, self.arrayUserMessenger[indexPath.row].stringUrl) { result in
                        switch result{
                        case .success(let image):
                            self.arrayUserMessenger[indexPath.row].addProfilPicture(image)
                            self.tableView.reloadRows(at: [indexPath], with: .fade)
                        case .failure(_):
                            self.alerte.alerteVc(.errorCheckAroundUs, self)
                        }
                    }
            case .failure(_):
                self.alerte.alerteVc(.errorCheckAroundUs, self)
            }
        }
        }
        
    }
    
    
}
