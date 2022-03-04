//
//  resulInfo.swift
//  musicity
//
//  Created by Brian Friess on 03/12/2021.
//

import Foundation
import UIKit

//is the result info when we found a new user around us 
final class ResultInfo : Equatable {
    
    static func == (lhs: ResultInfo, rhs: ResultInfo) -> Bool {
        return true
    }

    var userID = ""
    var publicInfoUser = [String:Any]()
    var profilPicture : UIImage?
    var stringUrl = ""
    //the array for read to DDB
    var instrumentFireBase = [String]()
    //the array for read to DDB
    var styleFirbase = [String]()
    var distance = ""
    var activeMessengerUserId = [String : Any]()
    var activeMessengerUserIdFirebase = [String]()
    var haveNotification = false
    
    func addAllUserMessenger(_ idUserMessenger : [String]) {
        self.activeMessengerUserIdFirebase = idUserMessenger
        setDictionnaryUserIdMessenger()
    }
    
    //we create a dictionnary with our array for firebase
    private func setDictionnaryUserIdMessenger() {
        for i in 0...activeMessengerUserIdFirebase.count-1 {
            activeMessengerUserId[String(i)] = activeMessengerUserIdFirebase[i]
        }
    }
    
    //we add a distance in an user result 
    func addDistance(_ distance : String) {
        self.distance = distance
    }
    
    //we add a user Id in an user result
    func addUserId(_ userId : String) {
        userID = userId
    }
    
    //we regroup some functions in one function
    func addAllInfo(_ allinfo : [String : Any]) {
        addPublicInfo(allinfo[DataBaseAccessPath.publicInfoUser.returnAccessPath] as! [String : Any])
        addAllInstrument(allinfo[DataBaseAccessPath.instrument.returnAccessPath] as! [String])
        addStyle(allinfo[DataBaseAccessPath.style.returnAccessPath] as! [String])
    }
    
    // we add all public Info in an user result
    private func addPublicInfo(_ publicInfo : [String : Any]) {
        self.publicInfoUser = publicInfo
    }
    
    //we add all instuments in an user result
    private func addAllInstrument(_ instrument : [String]) {
        self.instrumentFireBase = instrument
    }
    
    //we add all Style in an user result
    private func addStyle(_ style : [String]) {
        self.styleFirbase = style
    }
    
    //we add a profil picture in an user result
    func addProfilPicture(_ image : UIImage) {
        self.profilPicture = image
    }
    
    //we add an url String in an user result
    func addUrlString(_ urlString : String) {
        self.stringUrl = urlString
    }
    
    //we check if the is a band or a musician 
    func checkIfItsBandOrMusician() -> String {
        return publicInfoUser[DataBaseAccessPath.bandOrMusician.returnAccessPath] as! String
    }
    
}
