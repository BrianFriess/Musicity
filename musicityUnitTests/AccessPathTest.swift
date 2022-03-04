//
//  AccessPathTest.swift
//  musicityUnitTests
//
//  Created by Brian Friess on 12/02/2022.
//

import XCTest
@testable import musicity

class AccessPathTest: XCTestCase {

    func testReturnAccessPath() {
        XCTAssertEqual(DataBaseAccessPath.username.returnAccessPath, "username")
        XCTAssertEqual(DataBaseAccessPath.bandOrMusician.returnAccessPath, "BandOrMusician")
        XCTAssertEqual(DataBaseAccessPath.publicInfoUser.returnAccessPath, "publicInfoUser")
        XCTAssertEqual(DataBaseAccessPath.nbMember.returnAccessPath, "NbMember")
        XCTAssertEqual(DataBaseAccessPath.style.returnAccessPath, "Style")
        XCTAssertEqual(DataBaseAccessPath.instrument.returnAccessPath, "Instrument")
        XCTAssertEqual(DataBaseAccessPath.bio.returnAccessPath, "Bio")
        XCTAssertEqual(DataBaseAccessPath.youtubeUrl.returnAccessPath, "YoutubeUrl")
        XCTAssertEqual(DataBaseAccessPath.messenger.returnAccessPath, "Messenger")
        XCTAssertEqual(DataBaseAccessPath.messengerUserId.returnAccessPath, "MessengerUserId")
        XCTAssertEqual(DataBaseAccessPath.distance.returnAccessPath, "Distance")
        XCTAssertEqual(DataBaseAccessPath.search.returnAccessPath, "Search")
        XCTAssertEqual(DataBaseAccessPath.notification.returnAccessPath, "Notification")
        XCTAssertEqual(DataBaseAccessPath.notificationBanner.returnAccessPath, "NotificationBanner")
        XCTAssertEqual(DataBaseAccessPath.band.returnAccessPath, "Band")
        XCTAssertEqual(DataBaseAccessPath.member.returnAccessPath, "Membre(s)")
        XCTAssertEqual(DataBaseAccessPath.all.returnAccessPath, "All")
        XCTAssertEqual(DataBaseAccessPath.musician.returnAccessPath, "Musician")
        XCTAssertEqual(DataBaseAccessPath.messages.returnAccessPath, "Messages")
        XCTAssertEqual(DataBaseAccessPath.profilImage.returnAccessPath, "ProfilImage/profilImage.png")
        XCTAssertEqual(DataBaseAccessPath.idResult.returnAccessPath, "idResult")
    }

}
