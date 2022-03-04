//
//  AlerteManagerTest.swift
//  musicityUnitTests
//
//  Created by Brian Friess on 04/02/2022.
//

import XCTest
@testable import musicity

class AlerteManagerTest: XCTestCase {

    let alerteManager = AlertManager()
    let viewController = UIViewController()
    
    func testalerteManager() {
        alerteManager.alertVc(.errorCreateUser, viewController)
        alerteManager.alertVc(.lessSixPassword, viewController)
        alerteManager.alertVc(.emptyUsername, viewController)
        alerteManager.alertVc(.emptyEmail, viewController)
        alerteManager.alertVc(.falseEmail, viewController)
        alerteManager.alertVc(.errorConnexion, viewController)
        alerteManager.alertVc(.emptyPassword, viewController)
        alerteManager.alertVc(.emptyNbInstrument, viewController)
        alerteManager.alertVc(.emptyNbMembre, viewController)
        alerteManager.alertVc(.errorGetInfo, viewController)
        alerteManager.alertVc(.errorSetInfo, viewController)
        alerteManager.alertVc(.errorLogOut, viewController)
        alerteManager.alertVc(.errorImage, viewController)
        alerteManager.alertVc(.cantAccessPhotoLibrary, viewController)
        alerteManager.alertVc(.emptyInstrument, viewController)
        alerteManager.alertVc(.emptyProfilPicture, viewController)
        alerteManager.alertVc(.errorGeolocalisation, viewController)
        alerteManager.alertVc(.errorCheckAroundUs, viewController)
        alerteManager.alertVc(.deniedGeolocalisation, viewController)
        alerteManager.alertVc(.emptyStyle, viewController)
        alerteManager.alertVc(.tooMuchCara, viewController)
        alerteManager.alertVc(.youtubeLink, viewController)
        alerteManager.alertVc(.messageError, viewController)
    }
    
    func testAlertLocationManager() {
        alerteManager.locationAlert(.deniedGeolocalisation, viewController)        
    }

}
