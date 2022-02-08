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
    var data = fakeDataUnitTest()
    
    override func setUp() {
        super.setUp()
        firebaseManager = FirebaseManager()
    }
    
    //we use this for have a new email when we have a new test
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })+"@mail.com"
    }
    
    
    func testCreateUserTestMusicianAndTestConnextion_HaveAGoodData_MuisicianTestIsCreateAndConnexionIsOK(){
        let expectation = XCTestExpectation(description: "wait for queue change")
        firebaseManager.createNewUser(data.email, data.password, data.username, 0) { result in
           // expectation.fulfill()
            XCTAssertNotNil(result)
            self.firebaseManager.connexionUser(self.data.email, self.data.password) { result in
                expectation.fulfill()
                XCTAssertNotNil(result)
            }
        }
        wait(for: [expectation], timeout: 1)
    }
 
    
    func testCreateUserMusician_HaveAGoodData_MuisicianIsCreate(){
        let expectation = XCTestExpectation(description: "wait for queue change")
        firebaseManager.createNewUser(randomString(length: 10), data.password, data.username, 0) { result in
            expectation.fulfill()
            XCTAssertNotNil(result)
        }
        wait(for: [expectation], timeout: 1)
    }
    
    
    
    func testCreateUserBand_HaveAGoodData_BandIsCreate(){
        let expectation = XCTestExpectation(description: "wait for queue change")
        firebaseManager.createNewUser(randomString(length: 10), data.password, data.username, 1) { result in
            expectation.fulfill()
            XCTAssertNotNil(result)
        }
        wait(for: [expectation], timeout: 1)
    }

    func testCreateUserBand_HaveABadMail_BandIsNotCreate(){
        let expectation = XCTestExpectation(description: "wait for queue change")
        firebaseManager.createNewUser("mail", data.password, data.username, 1) { result in
            XCTAssertNotNil(result)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testCreateUserBand_HaveABadData_BandIsNotCreate(){
        let expectation = XCTestExpectation(description: "wait for queue change")
        firebaseManager.createNewUser(randomString(length: 10), data.password, data.username, 4) { result in
            XCTAssertNotNil(result)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    
    func testConnexionUser_BadData_UserIsNotConnect(){
        let expectation = XCTestExpectation(description: "wait for queue change")
        firebaseManager.connexionUser(data.email, "wrongPassword") { result in
            expectation.fulfill()
            XCTAssertNotNil(result)
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testLogoutUser_GoodData_UserIsLogOutAndDontHaveUserId(){
        let expectation = XCTestExpectation(description: "wait for queue change")
        firebaseManager.logOut { result in
            //expectation.fulfill()
            XCTAssertNotNil(result)
            self.firebaseManager.getUserId { result in
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 1)
    }
    
    
    func testgetUserId_HaveAGoodData_HaveAUserId(){
        let expectation = XCTestExpectation(description: "wait for queue change")
        firebaseManager.getUserId { result in
            expectation.fulfill()
            XCTAssertNotNil(result)
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testTryToSetTheUserIdForTheTchatAndGetData_HaveARightData_SetTheUserIdForTheTchatAndGetData(){
        let expectation = XCTestExpectation(description: "wait for queue change")
        firebaseManager.setTheUserIdMessengerInDdb(data.userId, data.dictUserIdForTchat
       ) { result in
            expectation.fulfill()
           // XCTAssertNotNil(result)
            switch result{
            case .success(_):
                XCTAssert(true)
                self.firebaseManager.getTheUserIdMessengerToDdb(self.data.userId
               ) { result in
                    expectation.fulfill()
                    XCTAssertNotNil(result)
                }
            case .failure(_):
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 1)
    }
    
    
    
    func testTryToGetTheUserIdForTheTchat_HaveAFakeData_DontGetTheUserIdForTheTchat(){
        let expectation = XCTestExpectation(description: "wait for queue change")
        firebaseManager.getTheUserIdMessengerToDdb(data.fakeId
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
    
    func testTryToSetNewMessage_HaveARightData_SetNewMessage(){
        let expectation = XCTestExpectation(description: "wait for queue change")
        firebaseManager.setNewMessage(data.userId, data.otherUserId, ["0":"test"]
        ) { result in
            expectation.fulfill()
            XCTAssertNotNil(result)
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testTryToReadMessageInDDB_HaveARightDataButValueDontChange_ReturnNothing(){
        let expectation = XCTestExpectation(description: "wait for queue change")
        firebaseManager.readInMessengerDataBase(data.userId, data.otherUserId
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
    
    
    
    func testTryGetAllValueToDataBase_GiveAGoodId_HaveAllData(){
        
        let expectation = XCTestExpectation(description: "wait for queue change")
        firebaseManager.getAllTheInfoToFirebase(data.userId
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
       firebaseManager.getAllTheInfoToFirebase(data.fakeId
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
    
    
    func testGetDictionnaryInDDB_HaveABadValue_DontGetDictionnary(){
        let expectation = XCTestExpectation(description: "wait for queue change")
        firebaseManager.getDictionnaryInfoUserToFirebase(data.fakeId, .publicInfoUser
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
        firebaseManager.setDictionnaryUserInfo(data.userId, data.dictInstrument, .Instrument
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
    
    
    func testSetSingleInfoInDDBAndGetADict_HaveAGoodValue_SetSingleInfoAndGetDict(){
        let expectation = XCTestExpectation(description: "wait for queue change")
        firebaseManager.setSingleUserInfo(data.userId, .publicInfoUser, .username, "testIsOk"
        ) { result in
            //expectation.fulfill()
            XCTAssertNotNil(result)
            switch result{
            case .success(_):
                XCTAssert(true)
                self.firebaseManager.getDictionnaryInfoUserToFirebase(self.data.userId, .publicInfoUser
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
            case .failure(_):
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 1)
    }
    
    
    func testGetSingleInfoInDDB_HaveABadValue_DontGetSingleInfo(){
        let expectation = XCTestExpectation(description: "wait for queue change")
        firebaseManager.getSingleInfoUserToFirebase(data.fakeId, .publicInfoUser, .username
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
        wait(for: [expectation], timeout: 2)
    }
    
    
    func testSetAndGetSingleUserInfo_HaveAGoodValue_SetAndGetSingleUserInfo(){
        let expectation = XCTestExpectation(description: "wait for queue change")
        firebaseManager.setAndGetSingleUserInfo(data.userId, "testIsOk", .publicInfoUser, .username) { result in
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
    

    
   func testSetImageInFirebaseAndGetImage_HaveARightData_SetImageAndGetImage(){
        let imageTest = (UIImage(systemName: "star.fill"))
        let imageData = imageTest!.pngData()
        let expectation = XCTestExpectation(description: "wait for queue change")
       firebaseManager.setImageInFirebaseAndGetUrl(data.userId, imageData!) { result in
           // expectation.fulfill()
            XCTAssertNotNil(result)
           self.firebaseManager.getUrlImageToFirebase(self.data.userId) { result in

               XCTAssertNotNil(result)
               switch result{
               case .success(let url):
                   self.firebaseManager.getImageToFirebase(url) { result in
                       expectation.fulfill()
                       XCTAssertNotNil(result)
                   }
               case .failure(_):
                   XCTFail()
               }
           }
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetUrlImage_HaveABadData_DontHaveAUrl(){
        let expectation = XCTestExpectation(description: "wait for queue change")
        firebaseManager.getUrlImageToFirebase(data.fakeId) { result in
            expectation.fulfill()
            XCTAssertNotNil(result)
        }
        wait(for: [expectation], timeout: 1)
    }
    
    
    
    func testGetImage_HaveABadData_DontHaveImage(){
        let expectation = XCTestExpectation(description: "wait for queue change")
        firebaseManager.getUrlImageToFirebase(data.userId) { result in
            self.firebaseManager.getImageToFirebase("fake") { result in
                expectation.fulfill()
                XCTAssertNotNil(result)
            }
        }
        wait(for: [expectation], timeout: 1)
    }
    
    
    
}
