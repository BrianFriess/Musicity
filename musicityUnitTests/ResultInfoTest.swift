//
//  ResultInfoTest.swift
//  musicityUnitTests
//
//  Created by Brian Friess on 31/01/2022.
//

import XCTest
@testable import musicity

class ResultInfoTest: XCTestCase {

    var resultInfo = ResultInfo()
    var data = fakeDataUnitTest()
    
    override func setUp() {
        super.setUp()
        resultInfo = ResultInfo()
    }
    
    func testDontHaveUserInfo_AddInfo_HaveAUserInfo(){
        
        resultInfo.addAllInfo(data.exportUserDataBase)
        
        XCTAssert(resultInfo.instrumentFireBase == data.exportUserDataBase["Instrument"] as! [String])
        XCTAssert(resultInfo.styleFirbase == data.exportUserDataBase["Style"] as! [String])
    }
    
    
    func testDontHaveUserIdMessenger_AddUserId_HaveUserId(){
        
        let arrayOfId = data.exportUserDataBase["MessengerUserId"] as! [String]
        
        XCTAssert(resultInfo.activeMessengerUserIdFirebase == [] )
        
        resultInfo.addAllUserMessenger(arrayOfId)
        
        XCTAssert(resultInfo.activeMessengerUserIdFirebase == arrayOfId)
        
    }
    
    
    func testDontHaveADistanceFilter_AddDistance_HaveADistance(){
        XCTAssert(resultInfo.distance == "")
        
        resultInfo.addDistance("30")
        
        XCTAssert(resultInfo.distance == "30")
    }
    
    func testUserDontHaveAnId_AddAnId_UserHaveAnId(){
        let userId = "testId"
        
        XCTAssert(resultInfo.userID == "")
        
        resultInfo.addUserId(userId)
        
        XCTAssert(resultInfo.userID == userId)
        
    }
    
    func testDontHaveUrlPicture_AddInfo_HaveUrlPicture(){
        resultInfo.addAllInfo(data.exportUserDataBase)

        resultInfo.addUrlString(resultInfo.publicInfoUser["YoutubeUrl"] as! String)
        
        XCTAssert((resultInfo.stringUrl == resultInfo.publicInfoUser["YoutubeUrl"] as! String))
    }
    
    
    func testDontKnowIfItsBandOrMusician_CheckIfItsBandOrMusician_KnowIfItsBandOrMusician(){
        resultInfo.addAllInfo(data.exportUserDataBase)
        
        XCTAssert(resultInfo.checkIfItsBandOrMusician() == "Band")
    }
    
    func testDontHaveAprofilPicture_AddProfilPicture_HaveAprofilPicture(){
        XCTAssert(resultInfo.profilPicture == nil)
        resultInfo.addProfilPicture(data.image)
        XCTAssert(resultInfo.profilPicture != nil)
    }
    

}
