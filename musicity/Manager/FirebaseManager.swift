//
//  FirebaseManager.swift
//  musicity
//
//  Created by Brian Friess on 23/11/2021.
//

import Foundation
import Firebase
import UIKit




enum FirebaseError : Error{
    case createUserError
    case connexionError
    case logOutError
    case userIdError
    case InfoError
}

struct FirebaseManager{
    
    //reference for firebase
    let storage = Storage.storage(url : "gs://musicity-ff6d8.appspot.com").reference()
    let ref = Database.database(url: "https://musicity-ff6d8-default-rtdb.europe-west1.firebasedatabase.app").reference()
    
    
    //function for create new user
   func createNewUser(_ email : String, _ password : String, _ userName : String,_ segmented : Int, completion : @escaping(Result<Void, FirebaseError>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password){ authResult, error in
            if error != nil{
                completion(.failure(.createUserError))
            }else{
                let userID = Auth.auth().currentUser?.uid
                switch
                segmented{
                case 0 :
                    //create a musician account
                    let createUser: [String :Any] = [
                        "BandOrMusician" : "Musician",
                        "username" : userName
                    ]
                    ref.child("users").child(userID!).child("publicInfoUser").setValue(createUser)
                case 1 :
                    //create a band account
                    let createUser: [String :Any] = [
                        "BandOrMusician" : "Band",
                        "username" : userName
                    ]
                    ref.child("users").child(userID!).child("publicInfoUser").setValue(createUser)
                default:
                    break
                }
                completion(.success(()))
            }
        }
    }
    
    
    //this function is for check email and password for the connexion
    func connexionUser(_ email : String,_ password : String, completion : @escaping(Result<Void, FirebaseError>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if error != nil{
                completion(.failure(.connexionError))
            }else{
                completion(.success(()))
            }
        }
    }
    
    func logOut(completion : @escaping(Result<Void, FirebaseError>) -> Void)  {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch {
            completion(.failure(.logOutError))
        }
    }
    
    //we use this function for get the user id
    func getUserId(completion : @escaping(Result<String, FirebaseError>) -> Void) {
        if let userID = Auth.auth().currentUser?.uid{
            completion(.success(userID))
        } else {
            completion(.failure(.userIdError))
        }
    }
    
    
    //MARK: Configure string in fireBase
  
    
    func getTheUserIdMessengerToDdb(_ userId : String, completion : @escaping(Result<[String],FirebaseError>) -> Void){
        ref.child("users").child(userId).child(DataBaseAccessPath.messengerUserId.returnAccessPath).observeSingleEvent(of: .value) { snapshot in
            if let value = snapshot.value as? [String]{
                completion(.success(value))
            }else{
                completion(.failure(.InfoError))
            }
        }
    }
    
    
    func setTheUserIdMessengerInDdb(_ userId : String, _ userIdMessenger : [String:Any] , completion : @escaping(Result<Void, FirebaseError>)-> Void){
        ref.child("users").child(userId).child(DataBaseAccessPath.messengerUserId.returnAccessPath).setValue(userIdMessenger){ errorInfo, _ in
            guard errorInfo == nil else {
                completion(.failure(.connexionError))
                return
            }
            completion (.success(()))
        }
    }
    
    
    //we set a new message in our DDB
    func setNewMessage(_ userId : String, _ resultUserId : String, _ message : [String:Any], completion : @escaping(Result<Void, FirebaseError>) -> Void){
        observeKeyMessenger(userId, resultUserId) { result in
            switch result{
            case .success(let key):
                ref.child("Messages").child(key).childByAutoId().setValue(message) { errorInfo, _ in
                    guard errorInfo == nil else {
                        completion(.failure(.connexionError))
                        return
                    }
                    completion(.success(()))
                }
            case .failure(_):
                completion(.failure(.InfoError))
            }
        }
    }
    
    
    
    //we check if the child bewteen 2 users in messenger already exist
    private func observeKeyMessenger(_ userId : String,_ resultUserId : String, completion : @escaping(Result<String,FirebaseError>)-> Void){
        ref.child("Messages").observeSingleEvent(of: .value, with: { (snapshot) in
             if snapshot.hasChild(userId+resultUserId){
                 completion(.success(userId+resultUserId))

             }else{
                 completion(.success(resultUserId+userId))
             }
         })
        completion(.failure(.InfoError))
    }
    
    
    // thanks to this function, we read in our DBB when our DBB change
    func readInMessengerDataBase(_ userId : String,_ resultUserId : String, completion : @escaping(Result<[String : Any], FirebaseError>) -> Void){
        observeKeyMessenger(userId, resultUserId) { result in
            switch result{
            case .success(let key):
                ref.child("Messages").child(key).observe(.childAdded, with: { (snapshot) -> Void in
                    if let value = snapshot.value as?[String : Any]{
                        completion(.success(value))
                    } else {
                        completion(.failure(.InfoError))
                    }
                   })
            case .failure(_):
                completion(.failure(.InfoError))
            }
        }
    }
    
    
    
    
    //we get all dictionnarys info of one user to fireBase
    func getAllTheInfoToFirebase(_ userId : String, completion : @escaping(Result<[String : Any], FirebaseError>) -> Void){
        ref.child("users").child(userId).observe(.value) { snapshot in
            if let value = snapshot.value as?[String : Any] {
                completion(.success(value))
            } else {
                completion(.failure(.InfoError))
            }
        }
    }
    
    
    
    //get a dictionnary to firebase like all instrument or all style etc ...
    func getDictionnaryInfoUserToFirebase(_ userId : String, _ infoProfil : DataBaseAccessPath, completion : @escaping(Result<[String : Any], FirebaseError>)-> Void) {
        ref.child("users").child(userId).child("\(infoProfil.returnAccessPath)").observeSingleEvent(of: .value) { snapshot in
            if let value = snapshot.value as? [String : Any] {
                completion(.success(value))
            } else {
                completion(.failure(.InfoError))
            }
        }
    }
    
    
    //set a dictionnary in firebase(use for create profil)
    func setDictionnaryUserInfo(_ userId : String, _ infoUser : [String : Any], _ infoProfil : DataBaseAccessPath, completion : @escaping(Result<Void, FirebaseError>)-> Void) {
        ref.child("users").child(userId).child("\(infoProfil.returnAccessPath)").setValue(infoUser) { errorInfo, _ in
            guard errorInfo == nil else {
                completion(.failure(.connexionError))
                return
            }
        }
        completion(.success(()))
    }
    

    
    // set a single info in firebase
    func setSingleUserInfo(_ userId : String,_ firstChild : DataBaseAccessPath, _ secondChild : DataBaseAccessPath, _ infoUser: String, completion : @escaping(Result<Void, FirebaseError>)-> Void){
        ref.child("users").child(userId).child("\(firstChild.returnAccessPath)").child(secondChild.returnAccessPath).setValue(infoUser)
        completion(.success(()))
        
    }
    
    //get a single info to firebase
    func getSingleInfoUserToFirebase(_ userId : String, _ firstChild : DataBaseAccessPath,_ secondChild : DataBaseAccessPath, completion : @escaping(Result<String, FirebaseError>)-> Void){
        ref.child("users").child(userId).child("\(firstChild.returnAccessPath)").child(secondChild.returnAccessPath).observeSingleEvent(of: .value) { snapshot in
            if let value = snapshot.value as? String{
                completion(.success(value))
            }else{
                completion(.failure(.InfoError))
            }
        }
    }
    
    
    //thanks to the 2 function, we create a function who can set and get a dictionnary in firebase
   func setAndGetSingleUserInfo(_ userId : String, _ infoUser : String, _ firstChild : DataBaseAccessPath, _ secondChild : DataBaseAccessPath, completion : @escaping(Result<String,FirebaseError>)-> Void ){
        setSingleUserInfo(userId, firstChild, secondChild, infoUser){ result in
            switch result{
                case .success(_):
                getSingleInfoUserToFirebase(userId, firstChild, secondChild){ result in
                    switch result{
                        case .success(let resultInfo):
                            completion(.success(resultInfo))
                        case .failure(_):
                            completion(.failure(.connexionError))
                    }
                }
                case .failure(_):
                completion(.failure(.connexionError))
            }
        }
    }
    

    
    
    //MARK: configure image in fireBase
    
    // we set an image in firebase
    func setImageInFirebaseAndGetUrl(_ userId : String, _ imageData : Data, completion : @escaping(Result<String, FirebaseError>) -> Void ){
        storage.child(userId).child("ProfilImage/profilImage.png").putData(imageData, metadata: nil, completion: { _, error in
            guard error == nil else{
                completion(.failure(.connexionError))
                return
            }
            //we get the url of the image
            getUrlImageToFirebase(userId) { result in
                switch result{
                case .success(let urlImage):
                    completion(.success(urlImage))
                case .failure(_):
                    completion(.failure(.connexionError))
                }
            }
        })
    }

    
    //we get the urlImage for profil Picture
    func getUrlImageToFirebase(_ userId : String, completion : @escaping(Result<String, FirebaseError>) -> Void){
        self.storage.child(userId).child("ProfilImage/profilImage.png").downloadURL { url, error in
            guard let url = url, error == nil else{
                completion(.failure(.connexionError))
                return
            }
            let urlString = url.absoluteString
            completion(.success(urlString))
        }
    }

    
    
    // we get an image with an URL
    func getImageToFirebase(_ urlString : String, completion : @escaping(Result<UIImage,FirebaseError>) -> Void){
        guard let url = URL(string: urlString) else{
            return
        }
        let task = URLSession.shared.dataTask(with: url, completionHandler: {data, _, error in
            guard let data = data, error == nil else{
                completion(.failure(.connexionError))
                return
            }
           DispatchQueue.main.async {
                let image = UIImage(data : data)
                completion(.success(image!))
            }
        })
        task.resume()
    }
    
    
}
