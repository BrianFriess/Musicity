//
//  File.swift
//  musicity
//
//  Created by Brian Friess on 21/12/2021.
//

import Foundation

enum YoutubeError : Error{
    case errorLink
}

class YoutubeManager{
    
    func checkYoutubeLink(_ url :String, completion : @escaping(Result<String, YoutubeError>) -> Void){
        
        let youtubeSuffix = url.suffix(11)
        let youtubePrefixNavigator = "https://www.youtube.com/watch?v="
       // let youtubePrefixMobile = "https://youtu.be/"
        
        guard url.count == 43 || url.count == 28 else {
            completion(.failure(.errorLink))
            return
        }
        
        guard let youtubeUrl = URL(string: youtubePrefixNavigator + youtubeSuffix) else {
            completion(.failure(.errorLink))
            return
        }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with : youtubeUrl) { (data, response, error) in
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
