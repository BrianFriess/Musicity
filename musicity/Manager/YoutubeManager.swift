//
//  File.swift
//  musicity
//
//  Created by Brian Friess on 21/12/2021.
//

import Foundation
//import GameKit

enum YoutubeError : Error{
    case errorLink
}

class YoutubeManager{
    
    private var session : URLSession
    
    init (session : URLSession){
        self.session = session
    }
    
    func checkYoutubeLink(_ url :String, completion : @escaping(Result<String, YoutubeError>) -> Void){
        
        let youtubeSuffix = url.suffix(11)
        let youtubePrefixNavigator = "https://www.youtube.com/watch?v="

        // we check if it's a right youtube URL
        guard url.count == 43 || url.count == 28 else {
            completion(.failure(.errorLink))
            return
        }
        
        let youtubeUrl = URL(string: youtubePrefixNavigator + youtubeSuffix)
        
        let task = self.session.dataTask(with : youtubeUrl!) { (data, response, error) in
            DispatchQueue.main.async {
                guard let response = response  as? HTTPURLResponse, response.statusCode == 200, error == nil else{
                    completion(.failure(.errorLink))
                    return
                }
                completion(.success(String(youtubeSuffix)))
            }
        }
        task.resume()
    }
    
    
    
}
