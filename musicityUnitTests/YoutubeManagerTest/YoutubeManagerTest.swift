//
//  YoutubeManagerTest.swift
//  musicityUnitTests
//
//  Created by Brian Friess on 04/02/2022.
//

import XCTest
@testable import musicity

class YoutubeManagerTest: XCTestCase {

    var youtubeManager : YoutubeManager!
    
    override func setUp() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLTestProtocol.self]
        let session = URLSession(configuration: configuration)
        youtubeManager = YoutubeManager(session: session)
    }
    
    override func tearDown(){
        super.tearDown()
        youtubeManager = nil
    }
    
    let youtubeURL = "https://www.youtube.com/watch?v=6U2SuAGRj4s"

    
    func testYoutubeUrl_BadUrl_HaveAnError(){
        youtubeManager.checkYoutubeLink("test") { result in
            XCTAssertEqual(result, .failure(.errorLink))
        }
    }
    
    func testYoutubeUrl_HaveAGoodUrl_DontHaveError(){
        youtubeManager.checkYoutubeLink(youtubeURL) { result  in
            XCTAssertEqual(result, .success("6U2SuAGRj4s"))
        }
    }
    
    func testHaveAGoodData_UseNetworkCall_HaveAGoodResult(){

        URLTestProtocol.loadingHandler = { request in
              let response: HTTPURLResponse = FakeResponseYoutubeVideo.responseOK!
              let error: Error? = nil
              let data = FakeResponseYoutubeVideo.data
              return (response, data, error)
          }
        
        let expectation = XCTestExpectation(description: "wait for queue change")
        
        youtubeManager.checkYoutubeLink(youtubeURL) { result in
            XCTAssertEqual(result, .success("6U2SuAGRj4s"))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testHaveABadData_UseNetworkCall_HaveABadResult(){

        URLTestProtocol.loadingHandler = { request in
              let response: HTTPURLResponse = FakeResponseYoutubeVideo.responseKO!
              let error: Error? = nil
              let data = FakeResponseYoutubeVideo.data
              return (response, data, error)
          }
        
        let expectation = XCTestExpectation(description: "wait for queue change")
        
        youtubeManager.checkYoutubeLink(youtubeURL) { result in
            XCTAssertEqual(result, .failure(.errorLink))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
}




