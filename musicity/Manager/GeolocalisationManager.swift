//
//  GeolocalisationManager.swift
//  musicity
//
//  Created by Brian Friess on 02/12/2021.
//

import Foundation
import GeoFire
import CoreLocation

enum GeolocalisationError : Error{
    case errorSetLocalisation
    case errorCheckAround
}

class GeolocalisationManager{
    
    let manager = CLLocationManager()
    
    private let geofireRef = Database.database(url: "https://musicity-ff6d8-default-rtdb.europe-west1.firebasedatabase.app").reference().child(DataBaseAccessPath.userLocation.returnAccessPath)
    
    
    enum AccessGeolocalisation{
        case accepted
        case denied
        case notDetermined
    }
    
    //we check if the user autorizes the geolocalisation
    func checkIfGeolocalisationIsActive() -> AccessGeolocalisation{
        let locationManager = CLLocationManager()
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
            case .restricted, .denied:
                return .denied
            case .authorizedAlways, .authorizedWhenInUse:
                return .accepted
            case .notDetermined:
                return .notDetermined
            @unknown default:
                return .denied
            }
        } else {
            return .denied
        }
    }
    
    
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
    func checkAround(_ latitude : Double, _ longitude : Double,_ distance : Double, completion : @escaping(Result<[String : String],GeolocalisationError>) -> Void){
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
            let distanceFromUser = Int(center.distance(from: location)/1000)
            
            let dictionnaryResult = (["idResult": key!, "distance" : String(distanceFromUser)])
            completion(.success(dictionnaryResult))
        })
    }
    

    

    
    
    
}
