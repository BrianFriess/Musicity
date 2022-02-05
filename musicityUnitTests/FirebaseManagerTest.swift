//
//  FirebaseManagerTest.swift
//  musicityUnitTests
//
//  Created by Brian Friess on 02/02/2022.
//

import Firebase
import XCTest
@testable import musicity
import SwiftUI


class FirebaseManagerTest: XCTestCase {

    var firebaseManager = FirebaseManager()
    var simulatorRef = FirebaseReference.refSimulator
    var simulatorStorage = FirebaseReference.storageSimulator
    var data = fakeDataUnitTest()
    
    override func setUp() {
        super.setUp()
        firebaseManager = FirebaseManager()
        simulatorRef = FirebaseReference.refSimulator
        simulatorStorage = FirebaseReference.storageSimulator
    }
    
    
    /*let auth = Auth.auth().useEmulator(withHost:"localhost", port:9099)*/
    let userId = "EE26Vbno8YglrpQ1PWCzdOTqtpN2"
    let otherUserId = "d8Imq5hvdaX1cUjKOeSZPwfrN4i2"
    let fakeId = "Fake"
    
    
    func testTryGetAllValueToDataBase_GiveAGoodId_HaveAllData(){
        
        let expectation = XCTestExpectation(description: "wait for queue change")
        firebaseManager.getAllTheInfoToFirebase(simulatorRef, userId
        ) { result in
            expectation.fulfill()
            XCTAssertNotNil(result)
            switch result{
            case .success(_):
                XCTAssert(true)
            case .failure(_):
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testTryGetAllValueToDataBase_GiveAFakeId_DontHaveAllData(){
        
        let expectation = XCTestExpectation(description: "wait for queue change")
        firebaseManager.getAllTheInfoToFirebase(simulatorRef, fakeId
        ) { result in
            expectation.fulfill()
            XCTAssertNotNil(result)
            switch result{
            case .success(_):
                XCTFail()
            case .failure(_):
                XCTAssert(true)
            }
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testTryToGetTheUserIdForTheTchat_HaveARightData_GetTheUserIdForTheTchat(){
        let expectation = XCTestExpectation(description: "wait for queue change")
        firebaseManager.getTheUserIdMessengerToDdb(simulatorRef, userId
       ) { result in
            expectation.fulfill()
            XCTAssertNotNil(result)
            switch result{
            case .success(_):
                XCTAssert(true)
            case .failure(_):
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testTryToGetTheUserIdForTheTchat_HaveAFakeData_DontGetTheUserIdForTheTchat(){
        let expectation = XCTestExpectation(description: "wait for queue change")
        firebaseManager.getTheUserIdMessengerToDdb(simulatorRef, fakeId
       ) { result in
            expectation.fulfill()
            XCTAssertNotNil(result)
            switch result{
            case .success(_):
                XCTFail()
            case .failure(_):
                XCTAssert(true)
            }
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testTryToSetTheUserIdForTheTchat_HaveARightData_SetTheUserIdForTheTchat(){
        let expectation = XCTestExpectation(description: "wait for queue change")
        firebaseManager.setTheUserIdMessengerInDdb(simulatorRef, userId, data.dictUserIdForTchat
       ) { result in
            expectation.fulfill()
            XCTAssertNotNil(result)
            switch result{
            case .success(_):
                XCTAssert(true)
            case .failure(_):
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 1)
    }
    
    
  /*  func testTryToSetTheUserIdForTheTchat_HaveAFakeData_DontSetTheUserIdForTheTchat(){
        let expectation = XCTestExpectation(description: "wait for queue change")
        firebaseManager.setTheUserIdMessengerInDdb(simulatorRef, userId, "nok"
       ) { result in
            expectation.fulfill()
            XCTAssertNotNil(result)
            switch result{
            case .success(_):
                XCTFail()
            case .failure(_):
                XCTAssert(true)
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }*/
    
    func testTryToSetNewMessage_HaveARightData_SetNewMessage(){
        let expectation = XCTestExpectation(description: "wait for queue change")
        firebaseManager.setNewMessage(simulatorRef, userId, otherUserId, ["0":"test"]
        ) { result in
            expectation.fulfill()
            XCTAssertNotNil(result)
        }
        wait(for: [expectation], timeout: 1)
    }
    
    
    
    func testTryToReadMessageInDDB_HaveARightDataButValueDontChange_ReturnNothing(){
        let expectation = XCTestExpectation(description: "wait for queue change")
        firebaseManager.readInMessengerDataBase(simulatorRef, userId, otherUserId
        ) { result in
            expectation.fulfill()
            XCTAssertNotNil(result)
            switch result{
            case .success(_):
                XCTFail()
            case .failure(_):
                XCTAssert(true)
            }
        }
        wait(for: [expectation], timeout: 1)
    }
    
    
    func testGetDictionnaryInDDB_HaveARightValue_GetDictionnary(){
        let expectation = XCTestExpectation(description: "wait for queue change")
        firebaseManager.getDictionnaryInfoUserToFirebase(simulatorRef, userId, .publicInfoUser
        ) { result in
            expectation.fulfill()
            XCTAssertNotNil(result)
            switch result{
            case .success(_):
                XCTAssert(true)
            case .failure(_):
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 1)
    }
    
    
    func testGetDictionnaryInDDB_HaveABadValue_DontGetDictionnary(){
        let expectation = XCTestExpectation(description: "wait for queue change")
        firebaseManager.getDictionnaryInfoUserToFirebase(simulatorRef, fakeId, .publicInfoUser
        ) { result in
            expectation.fulfill()
            XCTAssertNotNil(result)
            switch result{
            case .success(_):
                XCTFail()
            case .failure(_):
                XCTAssert(true)
            }
        }
        wait(for: [expectation], timeout: 1)
    }
    
    
    func testSetDictionnaryInDDB_HaveAGoodValue_SetDictionnary(){
        let expectation = XCTestExpectation(description: "wait for queue change")
        firebaseManager.setDictionnaryUserInfo(simulatorRef, userId, data.dictInstrument, .Instrument
        ) { result in
            expectation.fulfill()
            XCTAssertNotNil(result)
            switch result{
            case .success(_):
                XCTAssert(true)
            case .failure(_):
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 1)
    }
    
    
    func testSetSingleInfoInDDB_HaveAGoodValue_SetSingleInfo(){
        let expectation = XCTestExpectation(description: "wait for queue change")
        firebaseManager.setSingleUserInfo(simulatorRef, userId, .publicInfoUser, .username, "testIsOk"
        ) { result in
            expectation.fulfill()
            XCTAssertNotNil(result)
            switch result{
            case .success(_):
                XCTAssert(true)
            case .failure(_):
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 1)
    }
    
    
    /*func testGetSingleInfoInDDB_HaveAGoodValue_GetSingleInfo(){
        let expectation = XCTestExpectation(description: "wait for queue change")
        firebaseManager.getSingleInfoUserToFirebase(simulatorRef, userId, .publicInfoUser, .username
        ) { result in
            expectation.fulfill()
            XCTAssertNotNil(result)
            switch result{
            case .success(_):
                XCTAssert(true)
            case .failure(_):
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 1)
    }*/
    
    func testGetSingleInfoInDDB_HaveABadValue_DontGetSingleInfo(){
        let expectation = XCTestExpectation(description: "wait for queue change")
        firebaseManager.getSingleInfoUserToFirebase(simulatorRef, fakeId, .publicInfoUser, .username
        ) { result in
            expectation.fulfill()
            XCTAssertNotNil(result)
            switch result{
            case .success(_):
                XCTFail()
            case .failure(_):
                XCTAssert(true)
            }
        }
        wait(for: [expectation], timeout: 1)
    }
    
    
    func testSetAndGetSingleUserInfo_HaveAGoodValue_SetAndGetSingleUserInfo(){
        let expectation = XCTestExpectation(description: "wait for queue change")
        firebaseManager.setAndGetSingleUserInfo(simulatorRef, userId, "testIsOk", .publicInfoUser, .username) { result in
            expectation.fulfill()
            XCTAssertNotNil(result)
            switch result{
            case .success(_):
                XCTAssert(true)
            case .failure(_):
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 1)
    }
    
  /*  func testSetAndGetSingleUserInfo_HaveABadValue_DontSetAndGetSingleUserInfo(){
        let expectation = XCTestExpectation(description: "wait for queue change")
        firebaseManager.setAndGetSingleUserInfo(simulatorRef, fakeId, "testIsOk", .publicInfoUser, .username) { result in
            expectation.fulfill()
            XCTAssertNotNil(result)
           /* switch result{
            case .success(_):
                XCTFail()
            case .failure(_):
                XCTAssert(true)
            }*/
        }
        wait(for: [expectation], timeout: 1)
    }*/
    
  /*  func testSetImageInFirebase_HaveARightData_SetImage(){
       // let imageTest = (UIImage(systemName: "Icon.png")!)
        let imageTest = UIImage(named: "Icon.png")
        let imageData = imageTest?.pngData()
        let expectation = XCTestExpectation(description: "wait for queue change")
        firebaseManager.setImageInFirebaseAndGetUrl(simulatorStorage, userId, imageData!) { result in
            expectation.fulfill()
            XCTAssertNotNil(result)
        }
        wait(for: [expectation], timeout: 1)
    }*/
    
}
