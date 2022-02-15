//
//  MockResponseYoutube.swift
//  musicityUnitTests
//
//  Created by Brian Friess on 04/02/2022.
//

import Foundation



class FakeResponseYoutubeVideo{
    
    static let responseOK = HTTPURLResponse(url: URL(string: "https://google.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
       //faire une rÃ©ponse KO code 500
       static let responseKO = HTTPURLResponse(url: URL(string: "https://google.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)
    
    class YoutubeError: Error {}
    static let error = YoutubeError()
    
    static let youtubeIncorrectData = "erreur".data(using: .utf8)!
    
    static var youtubeCorrectData: Data?
    
    static var data = Data()

}
