//
//  UserInfoTest.swift
//  musicityUnitTests
//
//  Created by Brian Friess on 27/01/2022.
//

import XCTest
@testable import musicity

class UserInfoTest: XCTestCase {

    var userInfo = UserInfo.shared
    
    override func setUp() {
        super.setUp()
        
        userInfo = UserInfo.shared
    }
    
    
    func setOneStyleDictionnary() -> [Int:String]{
        return [0:"rock"]
    }
    
    func setTwoStyleDictionnay()-> [Int:String]{
        return [0:"rock" , 1:"metal"]
    }
    
    
    
    func setOneInstrumentDictionnary() -> [Int:String]{
        return [0:"rock"]
    }
    
    func setTwoInstrumentDictionnay()-> [Int:String]{
        return [0:"rock" , 1:"metal"]
    }
    
    
    func testStyleIsEmpty_SetOneStyle_StyleIsNotEmpty(){
        let dictStyle = setOneStyleDictionnary()
        
        userInfo.addStyle(dictStyle)
        
        XCTAssert(userInfo.style["0"] as! String == dictStyle[0]!)
    }
    
    
    func testStyleHaveTwoValue_UserChangeHisChoiceAndChooseJustOneStyle_HaveANewDictionnaryWithOneValue(){
        let dictOneStyle = setOneStyleDictionnary()
        let dictTwoStyles = setTwoStyleDictionnay()
        
        userInfo.addStyle(dictTwoStyles)
        
        userInfo.checkStyle(dictOneStyle.count, dictOneStyle)
        XCTAssert(UserInfo.shared.style.count == dictOneStyle.count)
    }

    
    
    func testInstrumentIsEmpty_SetOneInstrument_InstrumentIsNotEmpty(){
        let dictInstrument = setOneInstrumentDictionnary()
        
        userInfo.addInstrument(dictInstrument)
        
        XCTAssert(userInfo.instrument["0"] as! String == dictInstrument[0]!)
    }
    
    
    func testInstrumentHaveTwoValue_UserChangeHisChoiceAndChooseJustOneInstrument_HaveANewDictionnaryWithOneValue(){
        let dictOneInstrument = setOneInstrumentDictionnary()
        let dictTwoInstruments = setTwoInstrumentDictionnay()
        
        userInfo.addInstrument(dictTwoInstruments)
        
        userInfo.checkInstrument(dictOneInstrument.count, dictOneInstrument)
        XCTAssert(userInfo.instrument.count == dictOneInstrument.count)
    }
    

    
    func testUserInfoIsEmpty_RecoverAllTheInfoToTheDDB_UserInfoIsNotEmpty(){
        let userInfoExport = exportUserDataBase

        if userInfo.addAllInfo(userInfoExport){
            XCTAssert(userInfo.instrumentFireBase == userInfoExport["Instrument"] as! [String])
            XCTAssert(userInfo.styleFirbase == userInfoExport["Style"] as! [String])
 
        }
    }
        
    func testDontHaveAprofilPicture_AddProfilPicture_HaveAprofilPicture(){
        XCTAssert(userInfo.profilPicture == nil)
        
        userInfo.addProfilPicture(image)
        
        XCTAssert(userInfo.profilPicture != nil)
    }
    
        
    func testUserInfoIsEmpty_RecoverAllTheInfoToTheDDBWithError_UserInfoIsEmpty(){
            
        var userInfoExport = exportUserDataBase
        userInfoExport.removeAll()
        XCTAssert(userInfo.addAllInfo(userInfoExport) == false)
            
        userInfoExport = exportUserDataBase
        userInfoExport.removeValue(forKey: "Instrument")
        XCTAssert(userInfo.addAllInfo(userInfoExport) == false)
            
        userInfoExport = exportUserDataBase
        userInfoExport.removeValue(forKey: "Style")
        XCTAssert(userInfo.addAllInfo(userInfoExport) == false)
    }
    
    func testStyleIsEmpty_CheckIfDataIsEmptyOrNot(){
        XCTAssert(userInfo.checkIfStyleIsEmpty())
        
        XCTAssertFalse(userInfo.checkUrlProfilPicture())
        
        XCTAssert(userInfo.checkIfInstrumentIsEmpty())
    }
    
    func testurlStringIsEmpty_AddURLString_URLStringIsNotEmpty(){
        XCTAssert(userInfo.stringUrl == "")
        
        if userInfo.addAllInfo(exportUserDataBase){
            userInfo.addUrlString(userInfo.publicInfoUser["YoutubeUrl"] as! String)
            XCTAssert(userInfo.stringUrl == "6U2SuAGRj4s")
        }
    }
    
    func testUserInfoIsNotEmpty_CheckIfItsABandOrMusician_HaveAReturn(){
        if userInfo.addAllInfo(exportUserDataBase){
            XCTAssert(userInfo.checkIfItsBandOrMusician() == "Band")
        }
    }
    
    func testUserInfoIsNotEmpty_ResetAll_UserInfoIsEmpty(){
        if userInfo.addAllInfo(exportUserDataBase){
            userInfo.resetSingleton()
        }
        
        XCTAssert(userInfo.userID == ""  && userInfo.profilPicture == nil && userInfo.stringUrl == "" &&  userInfo.instrumentFireBase == [] &&  userInfo.styleFirbase == [] &&  userInfo.activeMessengerUserIdFirebase == [])
    }
    
    
    func testUserIdIsEmpty_AssUuserId_NotEmpty(){
        let testId = "testId"
        
        userInfo.addUserId(testId)
        
        XCTAssert(userInfo.userID == testId)
    }
    

}
