//
//  AlerteManagerTest.swift
//  musicityUnitTests
//
//  Created by Brian Friess on 04/02/2022.
//

import XCTest
@testable import musicity

class AlerteManagerTest: XCTestCase {

    let alerteManager = AlerteManager()
    let viewController = UIViewController()
    
    
    func testalerteManager(){
        alerteManager.alerteVc(.errorCreateUser, viewController)
        alerteManager.alerteVc(.LessSixPassword, viewController)
        alerteManager.alerteVc(.EmptyUsername, viewController)
        alerteManager.alerteVc(.EmptyEmail, viewController)
        alerteManager.alerteVc(.FalseEmail, viewController)
        alerteManager.alerteVc(.ErrorConnexion, viewController)
        alerteManager.alerteVc(.emptyPassword, viewController)
        alerteManager.alerteVc(.emptyNbInstrument, viewController)
        alerteManager.alerteVc(.emptyNbMembre, viewController)
        alerteManager.alerteVc(.errorGetInfo, viewController)
        alerteManager.alerteVc(.errorSetInfo, viewController)
        alerteManager.alerteVc(.errorLogOut, viewController)
        alerteManager.alerteVc(.errorImage, viewController)
        alerteManager.alerteVc(.cantAccessPhotoLibrary, viewController)
        alerteManager.alerteVc(.emptyInstrument, viewController)
        alerteManager.alerteVc(.emptyProfilPicture, viewController)
        alerteManager.alerteVc(.errorGeolocalisation, viewController)
        alerteManager.alerteVc(.errorCheckAroundUs, viewController)
        alerteManager.alerteVc(.deniedGeolocalisation, viewController)
        alerteManager.alerteVc(.emptyStyle, viewController)
        alerteManager.alerteVc(.tooMuchCara, viewController)
        alerteManager.alerteVc(.youtubeLink, viewController)
        alerteManager.alerteVc(.messageError, viewController)
    }
    
    
    func testAlertLocationManager(){
        alerteManager.locationAlerte(.deniedGeolocalisation, viewController)        
    }

}
