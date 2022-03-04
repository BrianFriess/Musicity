//
//  SegueManagerTest.swift
//  musicityUnitTests
//
//  Created by Brian Friess on 04/03/2022.
//

import XCTest
@testable import musicity

class SegueManagerTest: XCTestCase {

    func testSegueManager() {
        XCTAssertEqual(SegueManager.goToMusicitySegue.returnSegueString, "goToMusicitySegue")
        XCTAssertEqual(SegueManager.goToFirstConnexionSegue.returnSegueString, "goToFirstConnexionSegue")
        XCTAssertEqual(SegueManager.goToChoiceInstruSegue.returnSegueString, "goToChoiceInstruSegue")
        XCTAssertEqual(SegueManager.goToWelcomeSegue.returnSegueString, "goToWelcomeSegue")
        XCTAssertEqual(SegueManager.goToMusicityFromWelcome.returnSegueString, "goToMusicityFromWelcome")
        XCTAssertEqual(SegueManager.segueDisconnect.returnSegueString, "segueDisconnect")
        XCTAssertEqual(SegueManager.goToMissInformation.returnSegueString, "goToMissInformation")
        XCTAssertEqual(SegueManager.segueToFilter.returnSegueString, "segueToFilter")
        XCTAssertEqual(SegueManager.goToViewUserProfil.returnSegueString, "goToViewUserProfil")
        XCTAssertEqual(SegueManager.segueToFirstTimeMessenger.returnSegueString, "segueToFirstTimeMessenger")
        XCTAssertEqual(SegueManager.segueToMessenger.returnSegueString, "segueToMessenger")
        XCTAssertEqual(SegueManager.segueToViewProfilInMessenger.returnSegueString, "segueToViewProfilInMessenger")
    }
    
}
