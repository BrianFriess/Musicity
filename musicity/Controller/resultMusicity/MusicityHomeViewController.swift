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
import WebKit




class MusicityHomeViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
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
    private var checkFilterDistance = 0.0
    private var checkFilterSearch = ""
    
    

    
    //call the geolocalisation
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfWeAlreadyConnect()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()

    }
    
    //we check in firebase if the user is already connect
    func checkIfWeAlreadyConnect(){
        if Firebase.Auth.auth().currentUser == nil {
            self.performSegue(withIdentifier: "segueDisconnect", sender: nil)
        } else {
            getAllValueOfUserIfWeAreAlreadyConnect()
        }
    }
    
    //if the user is already connect, we get all the info at the start
    func getAllValueOfUserIfWeAreAlreadyConnect(){
                //we get the userID
        self.firebaseManager.getUserId { result in
            switch result{
            case .success(let userId):
                UserInfo.shared.addUserId(userId)
                //we read all the information in the DDB
                self.firebaseManager.getAllTheInfoToFirebase(userId) { result in
                    switch result{
                    case .success(let allInfo):
                        //if we have all the information, we get the information in the singleton
                        let allInfoIsGet = UserInfo.shared.addAllInfo(allInfo)
                        if allInfoIsGet {
                            //get the url profil picture
                            self.firebaseManager.getUrlImageToFirebase(userId) { resultImage in
                                switch resultImage{
                                case .success(let imageUrl):
                                    //get the profil Picture url in the singleton and go to the next page
                                    UserInfo.shared.addUrlString(imageUrl)
                                case .failure(_):
                                    self.alerte.alerteVc(.errorGetInfo, self)
                                }
                            }
                        } else {
                            self.disconnect()
                        }
                    case .failure(_):
                        self.alerte.alerteVc(.errorGetInfo, self)
                    }
                }
            case .failure(_):
                self.alerte.alerteVc(.errorGetInfo, self)
            }
        }
    }
    
   private func disconnect(){
        firebaseManager.logOut { result in
            switch result{
            case .success(_):
                print("logout")
                self.performSegue(withIdentifier: "segueDisconnect", sender: nil)
            case .failure(_):
                self.alerte.alerteVc(.errorLogOut, self)
            }
        }
    }
    
    //we use this to disconnect the user
    @IBAction func disconnectButton(_ sender: Any) {
        disconnect()
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
                self.checkFilterAroundUs()
            case .failure(_):
                self.alerte.alerteVc(.errorGeolocalisation, self)
            }
        }
    }
    
    
    //we check if the user use a filter or not
    private func checkFilterAroundUs(){
        if UserInfo.shared.filter["Distance"] == nil{
            //if we haven't filter, the distance by default is 25
            checkAroundUsFilter(25.0, "All")
        }
        else if UserInfo.shared.filter["Distance"] as! Double != checkFilterDistance || UserInfo.shared.filter["Search"] as? String != checkFilterSearch  {
            checkFilterDistance = UserInfo.shared.filter["Distance"] as! Double
            checkFilterSearch = (UserInfo.shared.filter["Search"] as! String)
            arrayUser = []
            collectionView.reloadData()
            checkAroundUsFilter(UserInfo.shared.filter["Distance"] as! Double, UserInfo.shared.filter["Search"] as! String )
        }
    }
    
    
    //we cbeck the user around use thanks to "distance"
    private func checkAroundUsFilter(_ distance : Double, _ bandOrMusicianFilter : String){
        geolocalisationManager.checkAround(latitude, longitude, distance ) { result in
            //we create an instance of ResultInfo and we get all the value in
            let userResult = ResultInfo()
            switch result{
                //we get the result user Id and the distance
            case .success(let resultArrayGeo):
                userResult.addUserId(resultArrayGeo["idResult"]!)
                userResult.addDistance(resultArrayGeo["distance"]!)
                //network call for check if the result is band or Musician
                self.firebaseManager.getSingleInfoUserToFirebase(resultArrayGeo["idResult"]!, .publicInfoUser, .BandOrMusician) { result in
                    switch result{
                    case .success(let checkBandOrMusician):
                        //we get the url info of the result
                        self.firebaseManager.getUrlImageToFirebase(resultArrayGeo["idResult"]!) { resultUrl in
                            switch resultUrl{
                            case .success(let url):
                                userResult.addUrlString(url)
                                //we check if this user is already in our array of Result if not, we add a new userResut in our array
                                if !self.checkIfUserAlreadyHere(userResult){
                                    self.filterBandOrMusician(checkBandOrMusician, bandOrMusicianFilter, userResult)
                                    self.collectionView.reloadData()
                                }
                            case .failure(_):
                                self.alerte.alerteVc(.errorCheckAroundUs, self)
                            }
                        }
                    case .failure(_):
                        print("nope")
                        self.alerte.alerteVc(.errorCheckAroundUs, self)
                    }
                }
            case .failure(_):
            self.alerte.alerteVc(.errorCheckAroundUs, self)
            }
        }
    }
    
    // we check with the network call result and the filter if we want Band or Musician or All
    func filterBandOrMusician(_ checkBandOrMusician : String, _ bandOrMusicianFilter : String, _ userResult : ResultInfo){
        if checkBandOrMusician == bandOrMusicianFilter{
            self.arrayUser.append(userResult)
        } else if bandOrMusicianFilter == "All"{
            self.arrayUser.append(userResult)
        }
    }
    
    
    
    //we check if the user who found around us is already in our array or if the result is us 
    private func checkIfUserAlreadyHere(_ user : ResultInfo) -> Bool{
        for currentUser in arrayUser{
            if currentUser.userID == user.userID || UserInfo.shared.userID == user.userID{
                return true
            }
        }
        return false
    }
    
}





extension MusicityHomeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
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
        
        cell.displayArrow(indexPath.row, arrayUser.count)
        
        //we check if we have already a username, if yes, we display the name and we display the scrollView and the distance
        if let username = arrayUser[indexPath.row].publicInfoUser[DataBaseAccessPath.username.returnAccessPath] as? String{
            cell.isHidden = false
            cell.usernameLabel.text = username
            cell.createScrollView(arrayUser[indexPath.row].instrumentFireBase, arrayUser[indexPath.row].styleFirbase)
            cell.configDistanceLabel(arrayUser[indexPath.row].distance)
            cell.configureBandOrMusicianLabel(arrayUser[indexPath.row].publicInfoUser[DataBaseAccessPath.BandOrMusician.returnAccessPath] as! String)
        } else {
            cell.isHidden = true
            cell.usernameLabel.text = ""
            cell.configureBandOrMusicianLabel("")
            cell.configDistanceLabel("")
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
    
    //set the value at the cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let screenSize : CGSize = UIScreen.main.bounds.size
        let heightSize  = view.safeAreaLayoutGuide.layoutFrame.size.height
        return CGSize(width: screenSize.width , height: heightSize)
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





