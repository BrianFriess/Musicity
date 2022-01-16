//
//  userInfo.swift
//  musicity
//
//  Created by Brian Friess on 24/11/2021.
//

import Foundation
import UIKit

class UserInfo{
    
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
    

    func resetSingleton(){
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
    private func setStyle(_ row : String,_ style : String){
        self.style[row] = style
    }
    
    //we add in our dictionnary [String : Any] the style from a dictionnay [Int : String]
    func addStyle(_ dictStyle : [Int : String]){
        var i = 0
        for (_, style) in dictStyle{
            setStyle(String(i), style)
            i+=1
        }
    }
    
    //we use this function for check in the controller if the numbers of style select and the numbers of the style in the segue is the same or not
    //we make this function if the user click in the finish or continue button but he make return
    func checkStyle(_ dictCount : Int,_ dictStyle : [Int : String]){
        if dictCount < self.style.count{
            self.style = [:]
            addStyle(dictStyle)
        }
    }
    
    
    //creation or changement array instrument
    private func setInstrument(_ row : String,_ instrument : String){
        self.instrument[row] = instrument
    }
    
    //we add in our dictionnary [String : Any] the instruments from a dictionnay [Int : String]
    func addInstrument(_ dictInstrument : [Int : String]){
        var i = 0
        for (_, instrument) in dictInstrument{
            setInstrument(String(i), instrument)
            i+=1
        }
    }
    //we use this function for check in the controller if the numbers of instruments select and the numbers of the instruments in the segue is the same or not
    //we make this function if the user click in the finish or continue button but he make return
    func checkInstrument(_ dictCount : Int,_ dictInstrument : [Int : String]){
        if dictCount < self.instrument.count{
            self.instrument = [:]
            addInstrument(dictInstrument)
        }
    }
    
    
    
    //we give all the value at the singleton and we return a bool for check if all info is ok
    func addAllInfo(_ allinfo : [String : Any]) -> Bool{
        guard let publicInfo = allinfo[DataBaseAccessPath.publicInfoUser.returnAccessPath] as? [String : Any] else {
            return false
        }
        addPublicInfo(publicInfo)
        
        guard let allInstrument = allinfo[DataBaseAccessPath.Instrument.returnAccessPath] as? [String] else {
            return false
        }
        addAllInstrument(allInstrument)
        
        guard let allStyle = allinfo[DataBaseAccessPath.Style.returnAccessPath] as? [String] else {
            return false
        }
        
        addAllStyle(allStyle)
        
        if let allIdMessenger = allinfo[DataBaseAccessPath.messengerUserId.returnAccessPath] as? [String]{
            addAllUserMessenger(allIdMessenger)
            setDictionnaryUserIdMessenger()
        }
        return true
    }
    
    
    //we convert the array of Id in our DDB in an Dictionnary [String : Any]
    private func setDictionnaryUserIdMessenger(){
            for i in 0...activeMessengerUserIdFirebase.count-1{
                activeMessengerUserId[String(i)] = activeMessengerUserIdFirebase[i]
            }
    }

    
    func addUserId(_ userId : String){
        userID = userId
    }
    
    func addPublicInfo(_ publicInfo : [String : Any]){
        self.publicInfoUser = publicInfo
    }

    
    func addAllInstrument(_ instrument : [String]){
        self.instrumentFireBase = instrument
    }
    
    func addAllUserMessenger(_ idUserMessenger : [String]){
        self.activeMessengerUserIdFirebase = idUserMessenger
    }
    
    func addAllStyle(_ style : [String]){
        self.styleFirbase = style
    }
    
    func addProfilPicture(_ image : UIImage){
        self.profilPicture = image
    }
    
    
    func checkIfStyleIsEmpty() -> Bool {
        return !style.isEmpty
    }
    
    
    func checkUrlProfilPicture() -> Bool{
        return stringUrl != ""
    }
    
    func checkIfInstrumentIsEmpty() -> Bool{
        return !instrument.isEmpty
    }
    
    
    func addUrlString(_ stringUrlResult : String){
        self.stringUrl = stringUrlResult
    }
    
    func checkIfItsBandOrMusician() -> String{
        return publicInfoUser[DataBaseAccessPath.BandOrMusician.returnAccessPath] as! String
    }
        
}
