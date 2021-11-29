//
//  FirebaseManager.swift
//  musicity
//
//  Created by Brian Friess on 23/11/2021.
//

import Foundation
import Firebase

enum FirebaseError : Error{
    case createUserError
    case connexionError
}

struct FirebaseManager{
    
    let ref = Database.database(url: "https://musicity-ff6d8-default-rtdb.europe-west1.firebasedatabase.app").reference()
    
   func createNewUser(_ email : String, _ password : String, _ userName : String,_ segmented : Int, completion : @escaping(Result<Void, FirebaseError>) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password){ authResult, error in
            if error != nil{
                print(error.debugDescription)
                completion(.failure(.createUserError))
            }else{
                let userID = Auth.auth().currentUser?.uid
                
                switch
                segmented{
                case 0 :
                    let createUser: [String :Any] = [
                        "BandOrMusician" : "Musician",
                        "username" : userName
                    ]
                    ref.child("users").child(userID!).setValue(createUser)
                case 1 :
                    let createUser: [String :Any] = [
                        "BandOrMusician" : "Band",
                        "username" : userName
                    ]
                    ref.child("users").child(userID!).setValue(createUser)
                default:
                    break
                }
                completion(.success(()))
            }
        }
    }
    
    
    func connexionUser(_ email : String,_ password : String, completion : @escaping(Result<Void, FirebaseError>) -> Void){
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if error != nil{
                completion(.failure(.connexionError))
            }else{
                completion(.success(()))
            }
        }
    }
    
    
    
}
