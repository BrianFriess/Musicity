//
//  File.swift
//  musicity
//
//  Created by Brian Friess on 21/12/2021.
//

import Foundation

enum YoutubeError : Error {
    case errorLink
}

struct YoutubeManager {
    
    private var session : URLSession
    
    init (session : URLSession) {
        self.session = session
    }
    
    //we use this function for create a network call for check if the youtube Url exist or not
    func checkYoutubeLink(_ url :String, completion : @escaping(Result<String, YoutubeError>) -> Void) {
        let youtubeSuffix = url.suffix(11)
        let youtubePrefixNavigator = "https://www.youtube.com/watch?v="
        // we check if it's a right youtube URL
        guard url.count == 43 || url.count == 28 else {
            completion(.failure(.errorLink))
            return
        }
        let youtubeUrl = URL(string: youtubePrefixNavigator + youtubeSuffix)
        //test if we have a good url 
        let task = self.session.dataTask(with : youtubeUrl!) { (_, response, error) in
            DispatchQueue.main.async {
                //check the response and the error
                guard let response = response  as? HTTPURLResponse, response.statusCode == 200, error == nil else {
                    completion(.failure(.errorLink))
                    return
                }
                completion(.success(String(youtubeSuffix)))
            }
        }
        task.resume()
    }
    
}
