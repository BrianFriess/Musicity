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
import WebKit
import SwiftUI




class MusicityHomeViewController: UIViewController, CLLocationManagerDelegate {
    

    @IBOutlet var customView: MusicityHomeCustomView!
    private let manager = CLLocationManager()
    private let geolocalisationManager = GeolocalisationManager()
    private let firebaseManager = FirebaseManager()
    private var latitude = 0.0
    private var longitude = 0.0
    private let alerte = AlerteManager()
    private var arrayUser = [ResultInfo]()
    private var currentUser = ResultInfo()
    private var distanceFilter = 25.0
    private var checkFilter = 0.0
    
    
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
    private func checkIfGeolocalisationIsActive(){
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
    private func setGeolocalisationInDDB() {
        geolocalisationManager.setTheGeolocalisation(latitude, longitude, UserInfo.shared.userID) { result in
            switch result{
            case .success(_):
                self.checkFilterAfterGetUserAroundUs()
            case .failure(_):
                self.alerte.alerteVc(.errorGeolocalisation, self)
            }
        }
    }
    
    
    //we check if the user use a filter or not
    private func checkFilterAfterGetUserAroundUs(){
        if UserInfo.shared.filter["Distance"] == nil{
            //if we haven't filter, the distance by default is 25
            checkAroundUsFilter(25.0)
        }
        else if UserInfo.shared.filter["Distance"] as! Double != checkFilter{
            checkFilter = UserInfo.shared.filter["Distance"] as! Double
            arrayUser = []
            collectionView.reloadData()
            checkAroundUsFilter(UserInfo.shared.filter["Distance"] as! Double)
        }
    }
    
    
    //we cbeck the user around use thanks to "distance"
    private func checkAroundUsFilter(_ distance : Double){
        geolocalisationManager.checkAround(latitude, longitude, distance ) { result in
            //we create an instance of ResultInfo and we get all the value in
            let userResult = ResultInfo()
            switch result{
            case .success(let resultArrayGeo):
                userResult.addUserId(resultArrayGeo[0])
                userResult.addDistance(resultArrayGeo[1])
                self.firebaseManager.getUrlImageToFirebase(resultArrayGeo[0]) { resultUrl in
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
    
    
    
    private func checkIfUserAlreadyHere(_ user : ResultInfo) -> Bool{
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
        
        
        
        if let username = arrayUser[indexPath.row].publicInfoUser[DataBaseAccessPath.username.returnAccessPath] as? String{
            cell.usernameLabel.text = username
            cell.createScrollView(arrayUser[indexPath.row].instrumentFireBase, arrayUser[indexPath.row].styleFirbase)
            cell.configDistanceLabel(arrayUser[indexPath.row].distance) 
        }

        //we check if you have already the profil picture or not
        if let imageDisplay = arrayUser[indexPath.row].profilPicture {
            cell.loadPhoto(.isLoad, imageDisplay)
        } else {
            cell.loadPhoto(.isInLoading, nil)
        }
        return cell
    }
    
    //we prepare the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToViewUserProfil"{
            let successVC = segue.destination as! ResultUserProfilViewController
            successVC.currentUser = currentUser
        }
    }
    
    //if we click on one item, we display a new controller
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
                        self.firebaseManager.getImageToFirebase(self.arrayUser[indexPath.row].stringUrl) { result in
                            switch result{
                            case .success(let image):
                                self.arrayUser[indexPath.row].addProfilPicture(image)
                                self.collectionView.reloadData()
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





// extension for pagination
extension MusicityHomeViewController :  UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.x == collectionView.contentSize.width - scrollView.frame.size.width)
        {
            checkIfGeolocalisationIsActive()
        }
    }
    
}




