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
    var publicInfo = [String:Any]()
    var personalInfo = [String:Any]()
    var musicInfoUser = [String:Any]()
    var profilPicture : UIImage?
    var instrument = [String:Any]()
    //it's a return value for the instruments 
    var instrumentFireBase = [String]()
    
    
    func addUserId(_ userId : String){
        userID = userId
    }
    
    func addPublicInfo(_ publicInfo : [String : Any]){
        self.publicInfo = publicInfo
    }
    
    func addPersonalInfo(_ personalInfo : [String : Any]){
        self.personalInfo = personalInfo
    }
    
    func addMusicInfo(_ musicInfo : [String : Any]){
        self.musicInfoUser = musicInfo
    }
    
    enum UserInfoDictionnay{
        case publicInfo
        case personalInfo
        case musicInfoUser
        case instrument
    }
    
    func addSingleInfo(_ userInfo : String, _ userInfoDictionnay : UserInfoDictionnay , _ child  : String){
        
        switch userInfoDictionnay {
        case .publicInfo:
            self.publicInfo[child] = userInfo
        case .personalInfo:
            self.personalInfo[child] = userInfo
        case .musicInfoUser:
            self.musicInfoUser[child] = userInfo
       case .instrument:
            self.instrument[child] = userInfo
        }
    }
    
    func addAllInstrument(_ instrument : [String]){
        self.instrumentFireBase = instrument
    }
    
    func addProfilPicture(_ image : UIImage){
        self.profilPicture = image
    }
    

    func checkAllTheInstruments() -> Bool{
        let nbInstrument = instrument.count
        let checkInstrument = musicInfoUser["\(DataBaseAccessPath.NbInstrument)"] as? Int
        
        return nbInstrument == checkInstrument
    }
    
    func checkProfilPicture() -> Bool{
        
        return profilPicture != nil
    }
    
        
}
