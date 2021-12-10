//
//  resulInfo.swift
//  musicity
//
//  Created by Brian Friess on 03/12/2021.
//

import Foundation
import UIKit

class ResultInfo {


    var userID = ""
    var publicInfoUser = [String:Any]()
    var profilPicture : UIImage?
    var instrument = [String]()
    var urlString = ""
    

    func addUserId(_ userId : String){
        userID = userId
    }
    
    func addAllInfo(_ allinfo : [String : Any]){
        addPublicInfo(allinfo[DataBaseAccessPath.publicInfoUser.returnAccessPath] as! [String : Any])
        addAllInstrument(allinfo[DataBaseAccessPath.Instrument.returnAccessPath] as! [String])
    }
    
    private func addPublicInfo(_ publicInfo : [String : Any]){
        self.publicInfoUser = publicInfo
    }
    
    
    private func addAllInstrument(_ instrument : [String]){
        self.instrument = instrument
    }
    
    func addProfilPicture(_ image : UIImage){
        self.profilPicture = image
    }
    
    func addUrlString(_ urlString : String){
        self.urlString = urlString
    }
    

    
}
