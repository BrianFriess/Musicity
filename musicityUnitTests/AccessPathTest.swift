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
        XCTAssertEqual(DataBaseAccessPath.BandOrMusician.returnAccessPath, "BandOrMusician")
        XCTAssertEqual(DataBaseAccessPath.publicInfoUser.returnAccessPath, "publicInfoUser")
        XCTAssertEqual(DataBaseAccessPath.NbMember.returnAccessPath, "NbMember")
        XCTAssertEqual(DataBaseAccessPath.Style.returnAccessPath, "Style")
        XCTAssertEqual(DataBaseAccessPath.Instrument.returnAccessPath, "Instrument")
        XCTAssertEqual(DataBaseAccessPath.Bio.returnAccessPath, "Bio")
        XCTAssertEqual(DataBaseAccessPath.YoutubeUrl.returnAccessPath, "YoutubeUrl")
        XCTAssertEqual(DataBaseAccessPath.messenger.returnAccessPath, "Messenger")
        XCTAssertEqual(DataBaseAccessPath.messengerUserId.returnAccessPath, "MessengerUserId")
        XCTAssertEqual(DataBaseAccessPath.distance.returnAccessPath, "Distance")
        XCTAssertEqual(DataBaseAccessPath.search.returnAccessPath, "Search")
        XCTAssertEqual(DataBaseAccessPath.notification.returnAccessPath, "Notification")
    }

}
