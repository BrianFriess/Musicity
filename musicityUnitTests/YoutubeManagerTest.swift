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
    
    override func tearDown(){
        super.tearDown()
        youtubeManager = nil
    }
    
    let youtubeURL = "https://www.youtube.com/watch?v=6U2SuAGRj4s"

    
    func testYoutubeUrl_BadUrl_HaveAnError(){
        let expectation = XCTestExpectation(description: "wait for queue change")
        
        youtubeManager = YoutubeManager(session: URLSession(configuration: .default))
        
        youtubeManager.checkYoutubeLink("test") { result in
            XCTAssertEqual(result, .failure(.errorLink))
            expectation.fulfill()
        }
    }
    
    func testYoutubeUrl_HaveAGoodUrl_DontHaveError(){
        let expectation = XCTestExpectation(description: "wait for queue change")
        
        youtubeManager = YoutubeManager(session: URLSession(configuration: .default))
        
        youtubeManager.checkYoutubeLink(youtubeURL) { result  in
            XCTAssertEqual(result, .success("6U2SuAGRj4s"))
            expectation.fulfill()
        }
    }
}
