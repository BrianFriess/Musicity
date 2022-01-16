//
//  ProfilUserViewController.swift
//  musicity
//
//  Created by Brian Friess on 30/11/2021.
//

import UIKit
import YoutubePlayer_in_WKWebView

class ProfilUserViewController: UIViewController {

    @IBOutlet weak var profilPicture: UIImageView!
    @IBOutlet var profilUserView: ProfilPageView!
    @IBOutlet weak var usernameTextField: UILabel!
    @IBOutlet weak var youtubePlayer: WKYTPlayerView!
    @IBOutlet weak var nbMember: UILabel!
    var firebaseManager = FirebaseManager()
    @IBOutlet weak var bioLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureInformation()
        configureProfilPicture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        changeProfilPicture()
        checkIfBioIsEmptyOrNot()
        youtubeVideoOrNot()
    }

    //we check if we have the same picture, else, we change for the new picture
    func changeProfilPicture(){
        if profilPicture.image != UserInfo.shared.profilPicture{
            profilPicture.image = UserInfo.shared.profilPicture
        }
    }
    
    //check the informations for display the informations
    func configureInformation(){
        if UserInfo.shared.checkIfItsBandOrMusician() == "Band"{
            profilUserView.isBandOrMusician(.isBand)
            nbMember.text = ("\(UserInfo.shared.publicInfoUser [DataBaseAccessPath.NbMember.returnAccessPath] as! String) membre(s)")
        } else {
            profilUserView.isBandOrMusician(.isMusician)
        }
        usernameTextField.text = UserInfo.shared.publicInfoUser[DataBaseAccessPath.username.returnAccessPath] as? String
    }
    
    
    // network call for display the profil picture 
    func configureProfilPicture(){
        profilUserView.loadSpinner(.isInLoading)
            firebaseManager.getImageToFirebase(UserInfo.shared.stringUrl) { result in
                switch result{
                case .success(let profilPictureResult):
                    UserInfo.shared.addProfilPicture(profilPictureResult)
                    self.profilUserView.loadSpinner(.isLoad)
                    self.profilPicture.image = UserInfo.shared.profilPicture
                case .failure(_):
                    self.profilUserView.loadSpinner(.isLoad)
                    self.profilPicture.image = UIImage(systemName: "questionmark.circle.fill")!
                }
            }
    }
    
    //we check if the user have already a youtubeVideo
    func youtubeVideoOrNot(){
        if UserInfo.shared.publicInfoUser[DataBaseAccessPath.YoutubeUrl.returnAccessPath] as? String  == "" || UserInfo.shared.publicInfoUser[DataBaseAccessPath.YoutubeUrl.returnAccessPath] == nil {
            profilUserView.youtubePlayerIsEmpty(.isEmpty)
        } else {
            profilUserView.youtubePlayerIsEmpty(.isNotEmpty)
            youtubePlayer.load(withVideoId: UserInfo.shared.publicInfoUser[DataBaseAccessPath.YoutubeUrl.returnAccessPath] as! String)
        }
    }
    
    
    func checkIfBioIsEmptyOrNot(){
        //we check if the bio is empty or not
        if UserInfo.shared.publicInfoUser[DataBaseAccessPath.Bio.returnAccessPath] as? String  == "" || UserInfo.shared.publicInfoUser[DataBaseAccessPath.Bio.returnAccessPath] == nil {
            profilUserView.bioIsEmpty(.isEmpty)
        } else {
            //if the bio isn't empty,  we write the bio in the label text
            profilUserView.bioLabelText.text = UserInfo.shared.publicInfoUser[DataBaseAccessPath.Bio.returnAccessPath] as? String
        }
    }

}


// extension for the collection view
extension ProfilUserViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UserInfo.shared.instrumentFireBase.count + UserInfo.shared.styleFirbase.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCollectionCell", for : indexPath) as? TagCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        // we check if we give the value of instruments or Style
        if indexPath.row < UserInfo.shared.instrumentFireBase.count{
            //at first, we give the value of instruments
            cell.tagLabel.text = UserInfo.shared.instrumentFireBase[indexPath.row]
        } else {
            //second, the style
            cell.tagLabel.text = UserInfo.shared.styleFirbase[indexPath.row - UserInfo.shared.instrumentFireBase.count]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    
}
