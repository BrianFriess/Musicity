//
//  musicityHomeViewController.swift
//  musicity
//
//  Created by Brian Friess on 30/11/2021.
//

import UIKit
import CoreLocation
import Firebase
import NotificationBannerSwift

class MusicityHomeViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var customView: MusicityHomeCustomView!

    
    private let manager = CLLocationManager()
    private let geolocalisationManager = GeolocalisationManager()
    private let firebaseManager = FirebaseManager()
    private let alerte = AlerteManager()
    private var latitude = 0.0
    private var longitude = 0.0
    private var arrayUser = [ResultInfo]()
    private var currentUser = ResultInfo()
    private var checkFilterDistance = 0.0
    private var checkFilterSearch = ""
    

    
    //call the geolocalisation
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfWeAlreadyConnect()
        manager.delegate = self
        AppUtility.lockOrientation(.portrait)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        checkIfGeolocalisationIsActive()
    }
    
    
    private func configureGeolocalisation(){
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
    }
    
    
    
    //we check in firebase if the user is already connect
    private func checkIfWeAlreadyConnect(){
        if Firebase.Auth.auth().currentUser == nil {
            self.performSegue(withIdentifier: "segueDisconnect", sender: nil)
        } else {
            configureGeolocalisation()
            getAllValueOfUserIfWeAreAlreadyConnect()
            checkIfWeHaveNewMessage()
        }
    }
    
    //if the user is already connect, we get all the info at the start
    private func getAllValueOfUserIfWeAreAlreadyConnect(){
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
                        self.checkIfWeHaveAllInformations(allInfo, userId)
                    case .failure(_):
                        self.alerte.alerteVc(.errorGetInfo, self)
                    }
                }
            case .failure(_):
                self.alerte.alerteVc(.errorGetInfo, self)
            }
        }
    }
    
    
    //if we have all the information, we get the information in the singleton
    private func checkIfWeHaveAllInformations(_ allInfo : [String:Any], _ userId : String){
        let allInfoIsGet = UserInfo.shared.addAllInfo(allInfo)
        if allInfoIsGet {
            //get the url profil picture
            self.getUrlImageAtTheStart(userId)
        } else {
            self.logInButMissInformation()
        }
    }
    
    
    private func getUrlImageAtTheStart(_ userId : String){
        self.firebaseManager.getUrlImageToFirebase(userId) { resultImage in
            switch resultImage{
            case .success(let imageUrl):
                //get the profil Picture url in the singleton and go to the next page
                UserInfo.shared.addUrlString(imageUrl)
            case .failure(_):
                self.alerte.alerteVc(.errorGetInfo, self)
            }
        }
    }
    
    private func logInButMissInformation(){
        //we go to the viewController for enter all the informations
        firebaseManager.removeNotificationObserver(UserInfo.shared.userID)
        self.performSegue(withIdentifier: "goToMissInformation", sender: self)
    }
    
    
   private func disconnect(){
        firebaseManager.logOut { result in
            switch result{
            case .success(_):
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
    
    
    //when we click on the filter button
    @IBAction func filterButton(_ sender: Any) {
        performSegue(withIdentifier: "segueToFilter", sender: nil)
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
        switch geolocalisationManager.checkIfGeolocalisationIsActive(){
        case .accepted:
            customView.displayLabelGeolocalisation(.isActive)
            setGeolocalisationInDDB()
        case .notDetermined:
            checkIfGeolocalisationIsActive()
        case .denied:
            alerte.locationAlerte(.deniedGeolocalisation, self)
            customView.displayLabelGeolocalisation(.notActive)
        }
    }
    
    
    // set the value in DDB
    private func setGeolocalisationInDDB() {
        geolocalisationManager.setTheGeolocalisation(latitude, longitude, UserInfo.shared.userID) { result in
            switch result{
            case .success(_):
                self.checkFilter()
            case .failure(_):
                self.alerte.alerteVc(.errorGeolocalisation, self)
            }
        }
    }
    
    
    //we check if the user use a filter or not
    private func checkFilter(){
        if UserInfo.shared.filter[DataBaseAccessPath.distance.returnAccessPath] == nil{
            //if we haven't filter, the distance by default is 50
            checkAroundUsWithFilter(50.0, "All")
        }
        //if we have a filter, arrayUser is empty and we reload our collectionView With nothing before load  new informations
        else if UserInfo.shared.filter[DataBaseAccessPath.distance.returnAccessPath] as! Double != checkFilterDistance || UserInfo.shared.filter[DataBaseAccessPath.search.returnAccessPath] as? String != checkFilterSearch  {
            checkFilterDistance = UserInfo.shared.filter[DataBaseAccessPath.distance.returnAccessPath] as! Double
            checkFilterSearch = (UserInfo.shared.filter[DataBaseAccessPath.search.returnAccessPath] as! String)
            arrayUser = []
            collectionView.reloadData()
            checkAroundUsWithFilter(UserInfo.shared.filter[DataBaseAccessPath.distance.returnAccessPath] as! Double, UserInfo.shared.filter[DataBaseAccessPath.search.returnAccessPath] as! String )
        }
    }
    
    
    //we cbeck the user around use thanks to "distance"
    private func checkAroundUsWithFilter(_ distance : Double, _ bandOrMusicianFilter : String){
        geolocalisationManager.checkAround(latitude, longitude, distance + 0.99 ) { result in
            //we create an instance of ResultInfo and we get all the value in
            let userResult = ResultInfo()
            switch result{
                //we get the result user Id and the distance
            case .success(let resultArrayGeo):
              //  print(resultArrayGeo)
                userResult.addUserId(resultArrayGeo["idResult"]!)
                userResult.addDistance(resultArrayGeo["distance"]!)
                //network call for check if the result is band or Musician
                self.checkIfItsBandOrMusician(resultArrayGeo, userResult, bandOrMusicianFilter)
            case .failure(_):
            self.alerte.alerteVc(.errorCheckAroundUs, self)
            }
        }
    }
    
    
    //check if the result is a band or musician
    private func checkIfItsBandOrMusician(_ resultArrayGeo : [String:String],_ userResult : ResultInfo,_ bandOrMusicianFilter : String){
        self.firebaseManager.getSingleInfoUserToFirebase(resultArrayGeo["idResult"]!, .publicInfoUser, .BandOrMusician) { result in
            switch result{
            case .success(let checkBandOrMusician):
                //we get the url image of the result
                self.getTheUrlImage(resultArrayGeo, userResult, checkBandOrMusician, bandOrMusicianFilter)
            case .failure(_):
                self.alerte.alerteVc(.errorCheckAroundUs, self)
            }
        }
    }
    
    
    private func getTheUrlImage(_ resultArrayGeo : [String:String], _ userResult : ResultInfo,_ checkBandOrMusician : String, _ bandOrMusicianFilter : String){
        //we get the url image of the result
        self.firebaseManager.getUrlImageToFirebase( resultArrayGeo["idResult"]!) { resultUrl in
            switch resultUrl{
            case .success(let url):
                userResult.addUrlString(url)
                //we check if this user is already in our array of Result if not, we add a new userResut in our array
                self.updateArrayOfUserResult(checkBandOrMusician, userResult, bandOrMusicianFilter)
                self.checkIfArraysIsEmpty()
            case .failure(_):
                break
            }
        }
    }
    
    
    
    
    //we check after 4 seconds if we have a result or not
    private func checkIfArraysIsEmpty(){
        let seconds = 4.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds){
            if self.arrayUser == []{
                self.alerte.alerteVc(.errorCheckAroundUs, self)
            }
        }
    }

    //we check if this user is already in our array of Result if not, we add a new userResut in our array
    private func updateArrayOfUserResult(_ checkBandOrMusician : String, _ userResult : ResultInfo, _ bandOrMusicianFilter : String ){
        if !self.checkIfUserAlreadyHere(userResult){
            if userResult.userID != UserInfo.shared.userID{
            self.filterBandOrMusician(checkBandOrMusician, bandOrMusicianFilter, userResult)
                self.collectionView.reloadData()
            }
        }
    }
    
    
    //we check if the user who found around us is already in our array or if the result is us
    private func checkIfUserAlreadyHere(_ user : ResultInfo) -> Bool{
        for currentUser in arrayUser{
            if currentUser.userID == user.userID{
                return true
            }
        }
        return false
    }
    
    
    
    // we check with the network call result and the filter if we want Band or Musician or All
    func filterBandOrMusician(_ checkBandOrMusician : String, _ bandOrMusicianFilter : String, _ userResult : ResultInfo){
        if checkBandOrMusician == bandOrMusicianFilter{
            self.arrayUser.append(userResult)
        } else if bandOrMusicianFilter == "All"{
            self.arrayUser.append(userResult)
        }
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
        
        if segue.identifier == "segueToFilter"{
            let successVC = segue.destination as! FilterViewController
            successVC.latitude = latitude
            successVC.longitude = longitude
        }
    }
    
    //if we click on one item, we display a new controller
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentUser = arrayUser[indexPath.row]
        self.performSegue(withIdentifier: "goToViewUserProfil", sender: nil)
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        //we check if we already have the user's information in our array or not before dislpay information in the cell
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
    
    
    //set the size of the cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize : CGSize = UIScreen.main.bounds.size
        let heightSize  = view.safeAreaLayoutGuide.layoutFrame.size.height
        return CGSize(width: screenSize.width , height: heightSize)
    }
}





// extension for pagination
extension MusicityHomeViewController :  UIScrollViewDelegate{
    //if the user scroll at the right when the last user result is display, we reload a new data
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.x == collectionView.contentSize.width - scrollView.frame.size.width)
        {
            checkIfGeolocalisationIsActive()
        }
    }
}



//extension for activate the notification in the app
extension  MusicityHomeViewController {
    func checkIfWeHaveNewMessage(){
        //we check when we have a new notification in our DDB
        firebaseManager.checkNotificationBanner(UserInfo.shared.userID) { result in
           switch result{
               //when we have, we recover the name of the user who send a new message
            case .success(let notif):
               if let name = notif[DataBaseAccessPath.notificationBanner.returnAccessPath] {
                   //creation and display the notification banner
                   self.configureNotificationBanner(with : name as! String)
               }
               self.firebaseManager.removeNotificationBanner(UserInfo.shared.userID)
            case .failure(_):
                break
            }
        }
    }

    
    
    //we  create and display the notification with the name
    func configureNotificationBanner(with name : String){
        
        //create the banner
        let notificationBanner = GrowingNotificationBanner(title: "Nouveau message!", subtitle: "de \(name)", leftView: nil, rightView: nil, style: .warning, colors: nil)
        notificationBanner.dismissOnTap = true
        notificationBanner.dismissOnSwipeUp = true
        notificationBanner.animationDuration = 0.4
        
        //show the banner
        notificationBanner.show()
        
        //after 1.5 sec the banner is automaticaly dismiss
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            notificationBanner.dismiss()
        }
    }
    
}



