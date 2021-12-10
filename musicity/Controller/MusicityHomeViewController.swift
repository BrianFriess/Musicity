//
//  musicityHomeViewController.swift
//  musicity
//
//  Created by Brian Friess on 30/11/2021.
//

import UIKit
import CoreLocation
import Firebase
import GeoFire
import CoreMIDI
import CoreAudio




class MusicityHomeViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var customView: MusicityHomeCustomView!
    let manager = CLLocationManager()
    let geolocalisationManager = GeolocalisationManager()
    let firebaseManager = FirebaseManager()
    var latitude = 0.0
    var longitude = 0.0
    let alerte = AlerteManager()    
    var arrayUser = [ResultInfo]()
    var currentUser = ResultInfo()

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //call the geolocalisation
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        checkIfGeolocalisationIsActive()
    }
    
    //we get the localisation of the iPhone
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.first{
            latitude = loc.coordinate.latitude
            longitude = loc.coordinate.longitude
        }
    }
    
    
    //we check the status of localisation when the user change settings
    func locationManager(_ manager : CLLocationManager , didChangeAuthorization status : CLAuthorizationStatus){
         checkIfGeolocalisationIsActive()
    }
    
    
    //we check if the geolocalisation is actived or not
    func checkIfGeolocalisationIsActive(){
        let locationManager = CLLocationManager()
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
            case .restricted, .denied:
                alerte.locationAlerte(.deniedGeolocalisation, self)
                customView.displayLabelGeolocalisation(.notActive)
            case .authorizedAlways, .authorizedWhenInUse, .notDetermined:
                customView.displayLabelGeolocalisation(.isActive)
                setGeolocalisationInDDB()
            
            @unknown default:
                    break
            }
        } else {
            customView.displayLabelGeolocalisation(.notActive)
            alerte.locationAlerte(.deniedGeolocalisation, self)
        }
    }
    
    
    // set the value in DDB
    func setGeolocalisationInDDB() {
        geolocalisationManager.setTheGeolocalisation(latitude, longitude, UserInfo.shared.userID) { result in
            switch result{
            case .success(_):
                self.getArrayOfUserAroundUs()
            case .failure(_):
                self.alerte.alerteVc(.errorGeolocalisation, self)
            }
        }
    }
    
    //we get an array of user around us
    func getArrayOfUserAroundUs(){
        geolocalisationManager.checkAround(latitude, longitude, 50) { result in
            //we create an instance of ResultInfo and we get all the value in
            let userResult = ResultInfo()
            switch result{
            case .success(let userId):
                userResult.userID = userId
                    self.firebaseManager.getUrlImageToFirebase(userId) { resultUrl in
                        switch resultUrl{
                        case .success(let url):
                            userResult.addUrlString(url)
                            //we check if this user is already in our array of Result if not, we add a new userResut in our array
                            if !self.checkIfUserAlreadyHere(userResult){
                                self.arrayUser.append(userResult)
                                self.collectionView.reloadData()
                            }
                        case .failure(_):
                            self.alerte.alerteVc(.errorCheckAroundUs, self)
                        }
                    }
            case .failure(_):
                self.alerte.alerteVc(.errorCheckAroundUs, self)
            }
        }
    }
    
    func checkIfUserAlreadyHere(_ user : ResultInfo) -> Bool{
        for currentUser in arrayUser{
            if currentUser.userID == user.userID{
                return true
            }
        }
        return false
    }
    
}





extension MusicityHomeViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayUser.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellTileCollectionView", for: indexPath) as? TileCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.usernameLabel.text = arrayUser[indexPath.row].publicInfoUser[DataBaseAccessPath.username.returnAccessPath] as? String
        
        if let imageDisplay = arrayUser[indexPath.row].profilPicture {
            cell.profilPicture.image = imageDisplay
        } else{
            cell.profilPicture.image = UIImage(systemName: "questionmark.circle.fill")!
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToViewUserProfil"{
            let successVC = segue.destination as! ViewUserProfilViewController
            successVC.currentUser = currentUser
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentUser = arrayUser[indexPath.row]
        self.performSegue(withIdentifier: "goToViewUserProfil", sender: nil)
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        //we check if we already have the user's information in our array
        if arrayUser[indexPath.row].publicInfoUser[DataBaseAccessPath.username.returnAccessPath] == nil{
            self.firebaseManager .getAllTheInfoToFirebase(arrayUser[indexPath.row].userID) { result in
                switch result{
                case .success(let allInfo):
                    self.arrayUser[indexPath.row].addAllInfo(allInfo)
                    if self.arrayUser[indexPath.row].profilPicture == nil{
                        self.firebaseManager.getImageToFirebase(self.arrayUser[indexPath.row].urlString) { result in
                            switch result{
                            case .success(let image):
                                self.arrayUser[indexPath.row].addProfilPicture(image)
                                self.collectionView.reloadItems(at: [indexPath])
                            case .failure(_):
                                self.alerte.alerteVc(.errorCheckAroundUs, self)
                            }
                        }
                    }
                case .failure(_):
                    self.alerte.alerteVc(.errorCheckAroundUs, self)
                }
            }
        }
    }
    
    
}




