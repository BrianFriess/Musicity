//
//  GeolocalisationManager.swift
//  musicity
//
//  Created by Brian Friess on 02/12/2021.
//

import Foundation
import Firebase
import GeoFire
import CoreLocation

enum GeolocalisationError : Error{
    case errorSetLocalisation
    case errorCheckAround
}

class GeolocalisationManager{
    
    let geofireRef = Database.database(url: "https://musicity-ff6d8-default-rtdb.europe-west1.firebasedatabase.app").reference().child(DataBaseAccessPath.userLocation.returnAccessPath)
    
    
    // we set the localisation in our Database
    func setTheGeolocalisation(_ latitude : Double, _ longitude : Double, _ userID : String, completion : @escaping(Result<Void, GeolocalisationError>) -> Void){
        
        let geoFire = GeoFire(firebaseRef: geofireRef)
        
        geoFire.setLocation(CLLocation(latitude: latitude, longitude: longitude), forKey: userID ) { (error) in
            if error != nil{
                completion(.failure(.errorSetLocalisation))
            } else {
                completion(.success(()))
            }
        }
    }
    
    
    //we check around us in the DDB
    func checkAround(_ latitude : Double, _ longitude : Double,_ distance : Double, completion : @escaping(Result<String,GeolocalisationError>) -> Void){
        let geoFire = GeoFire(firebaseRef: geofireRef)
        let center = CLLocation(latitude: latitude, longitude: longitude)
        
        // we can set the distance around us for our research
        let circleQuery = geoFire.query(at: center, withRadius: distance)
        
        //return the userID 
        circleQuery.observe(.keyEntered, with: { (key: String!, location: CLLocation!) in
            guard key != nil else {
                completion(.failure(.errorCheckAround))
                return
            }
            completion(.success(key))
        })
    }
    
    
}
