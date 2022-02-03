//
//  FirebaseManagerTest.swift
//  musicityUnitTests
//
//  Created by Brian Friess on 02/02/2022.
//

import Firebase
import XCTest
@testable import musicity


class FirebaseManagerTest: XCTestCase {

    var firebaseManager = FirebaseManager()
    var simulatorRef = FirebaseReference.refSimulator
    var data = fakeDataUnitTest()
    
    override func setUp() {
        super.setUp()
        firebaseManager = FirebaseManager()
        simulatorRef = FirebaseReference.refSimulator
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
        wait(for: [expectation], timeout: 0.1)
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
    
    

}
