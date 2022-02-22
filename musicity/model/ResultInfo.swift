//
//  resulInfo.swift
//  musicity
//
//  Created by Brian Friess on 03/12/2021.
//

import Foundation
import UIKit

class ResultInfo : Equatable {
    
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
    

    func addAllUserMessenger(_ idUserMessenger : [String]){
        self.activeMessengerUserIdFirebase = idUserMessenger
        setDictionnaryUserIdMessenger()
    }
    
    //we create a dictionnary with our array for firebase
    private func setDictionnaryUserIdMessenger(){
            for i in 0...activeMessengerUserIdFirebase.count-1{
                activeMessengerUserId[String(i)] = activeMessengerUserIdFirebase[i]
            }
    }
    
    func addDistance(_ distance : String){
        self.distance = distance
    }
    
    func addUserId(_ userId : String){
        userID = userId
    }
    
    func addAllInfo(_ allinfo : [String : Any]){
        addPublicInfo(allinfo[DataBaseAccessPath.publicInfoUser.returnAccessPath] as! [String : Any])
        addAllInstrument(allinfo[DataBaseAccessPath.Instrument.returnAccessPath] as! [String])
        addStyle(allinfo[DataBaseAccessPath.Style.returnAccessPath] as! [String])
    }
    
    private func addPublicInfo(_ publicInfo : [String : Any]){
        self.publicInfoUser = publicInfo
    }
    
    
    private func addAllInstrument(_ instrument : [String]){
        self.instrumentFireBase = instrument
    }
    
    func addProfilPicture(_ image : UIImage){
        self.profilPicture = image
    }
    
    func addUrlString(_ urlString : String){
        self.stringUrl = urlString
    }
    
    private func addStyle(_ style : [String]){
        self.styleFirbase = style
    }

    func checkIfItsBandOrMusician() -> String{
        return publicInfoUser[DataBaseAccessPath.BandOrMusician.returnAccessPath] as! String
    }
    
}
