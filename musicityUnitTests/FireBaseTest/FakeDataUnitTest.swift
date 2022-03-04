//
//  ExportUserDataBAse.swift
//  musicityUnitTests
//
//  Created by Brian Friess on 30/01/2022.
//

import Foundation
import UIKit


struct fakeDataUnitTest{

    let exportUserDataBase = [
            "Instrument" :
                [ "guitare acoustique", "chant", "guitare electrique", "basse", "batterie" ],
            "MessengerUserId" :
                [ "GsI6eSkvjFT3gppDVNYanVLuwXr1" ],
            "Style" :
                [ "Blues", "Britpop", "Indies" ],
            "publicInfoUser" :
                ["BandOrMusician" : "Band",
                 "Bio" : "Test bio test bio",
                 "NbMember" : "4",
                 "YoutubeUrl" : "6U2SuAGRj4s",
                 "username" : "testgroupe1"
                ]
            ] as [String : Any]

    let image = UIImage()

    let email = "FakeEmail@mail.com"
    let password = "password"
    let username = "fakeUser"
    let userId = "EE26Vbno8YglrpQ1PWCzdOTqtpN2"
    let otherUserId = "d8Imq5hvdaX1cUjKOeSZPwfrN4i2"
    let fakeId = "Fake"

    let dictUserIdForTchat = ["0" :"GsI6eSkvjFT3gppDVNYanVLuwXr1"]
    
    let dictInstrument = [ "0":"guitare acoustique", "1":"chant", "2":"guitare electrique", "3":"basse", "4":"batterie" ]
}
