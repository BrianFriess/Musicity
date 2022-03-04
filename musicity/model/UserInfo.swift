//
//  userInfo.swift
//  musicity
//
//  Created by Brian Friess on 24/11/2021.
//

import Foundation
import UIKit

final class UserInfo {
    
    static var shared = UserInfo()
    private init() {}
    
    var userID = ""
    var publicInfoUser = [String:Any]()
    var profilPicture : UIImage?
    var stringUrl = ""
    //the dictionnary for write in DDB
    var instrument = [String:Any]()
    //the array for read to DDB
    var instrumentFireBase = [String]()
    //the dictionnary for write in DDB
    var style = [String: Any]()
    //the array for read to DDB
    var styleFirbase = [String]()
    var filter = [String: Any]()
    var activeMessengerUserId = [String : Any]()
    var activeMessengerUserIdFirebase = [String]()
    
    //reset the singleton for exemple when the user disconnect
    func resetSingleton() {
        userID = ""
        publicInfoUser = [:]
        profilPicture = nil
        stringUrl = ""
        instrument = [:]
        instrumentFireBase = []
        style = [:]
        styleFirbase = []
        filter = [:]
        activeMessengerUserId = [:]
        activeMessengerUserIdFirebase = []
    }

    //creation or changement array Style
    private func setStyle(_ row : String,_ style : String) {
        self.style[row] = style
    }
    
    //we add in our dictionnary [String : Any] the style from a dictionnay [Int : String]
    func addStyle(_ dictStyle : [Int : String]) {
        var i = 0
        for (_, style) in dictStyle {
            setStyle(String(i), style)
            i+=1
        }
    }
    
    //we use this function for check in the controller if the numbers of style select and the numbers of the style in the segue is the same or not
    //we make this function if the user click in the finish or continue button but he make return
    func checkStyle(_ dictCount : Int,_ dictStyle : [Int : String]) {
        if dictCount < self.style.count {
            self.style = [:]
            addStyle(dictStyle)
        }
    }
    
    //creation or changement array instrument
    private func setInstrument(_ row : String,_ instrument : String) {
        self.instrument[row] = instrument
    }
    
    //we add in our dictionnary [String : Any] the instruments from a dictionnay [Int : String]
    func addInstrument(_ dictInstrument : [Int : String]) {
        var i = 0
        for (_, instrument) in dictInstrument {
            setInstrument(String(i), instrument)
            i+=1
        }
    }
    //we use this function for check in the controller if the numbers of instruments select and the numbers of the instruments in the segue is the same or not
    //we make this function if the user click in the finish or continue button but he make return
    func checkInstrument(_ dictCount : Int,_ dictInstrument : [Int : String]) {
        if dictCount < self.instrument.count {
            self.instrument = [:]
            addInstrument(dictInstrument)
        }
    }
    
    //we give all the value at the singleton and we return a bool for check if all info is ok
    func addAllInfo(_ allinfo : [String : Any]) -> Bool {
        guard let publicInfo = allinfo[DataBaseAccessPath.publicInfoUser.returnAccessPath] as? [String : Any] else {
            return false
        }
        addPublicInfo(publicInfo)
        guard let allInstrument = allinfo[DataBaseAccessPath.instrument.returnAccessPath] as? [String] else {
            return false
        }
        addAllInstrument(allInstrument)
        guard let allStyle = allinfo[DataBaseAccessPath.style.returnAccessPath] as? [String] else {
            return false
        }
        addAllStyle(allStyle)
        if let allIdMessenger = allinfo[DataBaseAccessPath.messengerUserId.returnAccessPath] as? [String] {
            addAllUserMessenger(allIdMessenger)
            setDictionnaryUserIdMessenger()
        }
        return true
    }
    
    //we convert the array of Id in our DDB in an Dictionnary [String : Any]
    private func setDictionnaryUserIdMessenger() {
        for i in 0...activeMessengerUserIdFirebase.count-1 {
            activeMessengerUserId[String(i)] = activeMessengerUserIdFirebase[i]
        }
    }

    //add user id
    func addUserId(_ userId : String) {
        userID = userId
    }
    
    //add all the info in "publicInfo" in the ddb
    func addPublicInfo(_ publicInfo : [String : Any]) {
        self.publicInfoUser = publicInfo
    }
    
    //add all the instrument to ddb in the singleton
    private func addAllInstrument(_ instrument : [String]) {
        self.instrumentFireBase = instrument
    }
    
    //add all the userMessenger to ddb in the singleton
    func addAllUserMessenger(_ idUserMessenger : [String]) {
        self.activeMessengerUserIdFirebase = idUserMessenger
    }
    
    //add all the Style to ddb in the singleton
    private func addAllStyle(_ style : [String]) {
        self.styleFirbase = style
    }
    
    //add all the profilPicture to ddb in the singleton
    func addProfilPicture(_ image : UIImage) {
        self.profilPicture = image
    }
    
    //check if the style is empty or not when the user create his profil
    func checkIfStyleIsEmpty() -> Bool {
        return !style.isEmpty
    }
    
    //check if the url profil is empty or not when the user create his profil
    func checkUrlProfilPicture() -> Bool {
        return stringUrl != ""
    }
    
    //check if the instruments is empty or not when the user create his profil
    func checkIfInstrumentIsEmpty() -> Bool {
        return !instrument.isEmpty
    }
    
    //add the url string to ddb in the singleton
    func addUrlString(_ stringUrlResult : String) {
        self.stringUrl = stringUrlResult
    }
    
    //check if the user is a band or musician 
    func checkIfItsBandOrMusician() -> String {
        return publicInfoUser[DataBaseAccessPath.bandOrMusician.returnAccessPath] as! String
    }
    
}
