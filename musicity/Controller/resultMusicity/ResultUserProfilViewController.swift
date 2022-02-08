//
//  ViewUserProfilViewController.swift
//  musicity
//
//  Created by Brian Friess on 06/12/2021.
//

import UIKit
import YoutubePlayer_in_WKWebView

class ResultUserProfilViewController: UIViewController {
    

    @IBOutlet weak var tagResultCollection: UICollectionView!
    @IBOutlet var customeResultProfilPageView: ResultProfilPage!
    
    private let firebaseManager = FirebaseManager()
    private let alerteManager = AlerteManager()
    var currentUser = ResultInfo()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    //we use this function for configure the view with all the info in the model
    func configureView(){
        checkIfProfilPictureIsAlreadyLoad()
        checkIfBioIsEmpty()
        customeResultProfilPageView.configLabelUsername(currentUser.publicInfoUser[DataBaseAccessPath.username.returnAccessPath] as! String)
        bandOrMusician()
        youtubeVideoOrNot()
    }
    

    
    //we check if it's band or musician profil
    func bandOrMusician(){
        if currentUser.checkIfItsBandOrMusician() == "Band"{
            customeResultProfilPageView.isBandOrMusician(.isBand)
            customeResultProfilPageView.nbMemberLabel.text = ("\(currentUser.publicInfoUser[DataBaseAccessPath.NbMember.returnAccessPath] as! String) membre(s)")
        } else {
            customeResultProfilPageView.isBandOrMusician(.isMusician)
        }
    }
    
    //we check if the user have already a youtubeVideo
    func youtubeVideoOrNot(){
        if currentUser.publicInfoUser[DataBaseAccessPath.YoutubeUrl.returnAccessPath] as? String == "" || currentUser.publicInfoUser[DataBaseAccessPath.YoutubeUrl.returnAccessPath] == nil {
            customeResultProfilPageView.youtubePlayerIsEmpty(.isEmpty)
        } else {
            customeResultProfilPageView.youtubePlayerIsEmpty(.isNotEmpty)
            customeResultProfilPageView.youtubePlayer.load(withVideoId: currentUser.publicInfoUser[DataBaseAccessPath.YoutubeUrl.returnAccessPath] as! String)
        }
    }
    
    //we check if the profilPicture is already load in the front page, if not, we use our network call for display the profil picture
    func checkIfProfilPictureIsAlreadyLoad(){
        if currentUser.profilPicture == nil{
            customeResultProfilPageView.loadSpinner(.isInLoading)
            firebaseManager.getImageToFirebase( currentUser.stringUrl) { result in
                switch result{
                case .success(let image):
                    self.customeResultProfilPageView.loadSpinner(.isLoad)
                    self.customeResultProfilPageView.profilPicture.image = image
                case .failure(_):
                    self.alerteManager.alerteVc(.errorImage, self)
                    self.customeResultProfilPageView.loadSpinner(.isLoad)
                }
            }
        } else {
            customeResultProfilPageView.profilPicture.image = currentUser.profilPicture
        }
    }
    
    //we check the user have already a bio
    func checkIfBioIsEmpty(){
        if currentUser.publicInfoUser[DataBaseAccessPath.Bio.returnAccessPath] as? String == "" || currentUser.publicInfoUser[DataBaseAccessPath.Bio.returnAccessPath] == nil{
            customeResultProfilPageView.bioIsEmpty(.isEmpty)
        } else {
            customeResultProfilPageView.bioIsEmpty(.isNotEmpty)
            customeResultProfilPageView.bioLabelText.text = currentUser.publicInfoUser[DataBaseAccessPath.Bio.returnAccessPath] as? String
        }
    }
    
    //we prepare the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToFirstTimeMessenger"{
            let successVC = segue.destination as! TchatViewController
            successVC.currentUser = currentUser
        }
    }
    
    @IBAction func contactButton(_ sender: Any) {
       performSegue(withIdentifier: "SegueToFirstTimeMessenger", sender: self)
    }
        
    

}





extension ResultUserProfilViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentUser.instrumentFireBase.count + currentUser.styleFirbase.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCollectionResultCell", for : indexPath) as? TagCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        // we check if we give the value of instruments or Style
        if indexPath.row < currentUser.instrumentFireBase.count{
            //at first, we give the value of instruments
            cell.tagLabel.text = currentUser.instrumentFireBase[indexPath.row]
        } else {
            //second, the style
            cell.tagLabel.text = currentUser.styleFirbase[indexPath.row - currentUser.instrumentFireBase.count]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
}




