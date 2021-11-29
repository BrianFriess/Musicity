//
//  HomeViewController.swift
//  musicity
//
//  Created by Brian Friess on 20/11/2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CreateProfilViewController: UIViewController {

    @IBOutlet weak var infoLabelText: UILabel!
    
    override func viewDidLoad() {

            let ref = Database.database(url: "https://musicity-ff6d8-default-rtdb.europe-west1.firebasedatabase.app").reference()
            let userID = Auth.auth().currentUser?.uid
            ref.child("users").child(userID!).observeSingleEvent(of: .value) { snapshot in
                let value = snapshot.value as? NSDictionary
                let username = value?["username"] as? String ?? "no username"
                self.infoLabelText.text  = username
            }
            
    }
    
    
    @IBAction func logOutButton(_ sender: UIButton) {
        
        do{
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        }catch{
            print("error")
        }
    }
    
}
