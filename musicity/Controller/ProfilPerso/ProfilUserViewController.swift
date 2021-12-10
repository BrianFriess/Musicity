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

    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilUserView.configure()
        configureInformation()
        configureProfilPicture()
        
        //model + test du lien youtube // enlever finalement
        youtubePlayer.load(withVideoId: "6U2SuAGRj4s")
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
        if UserInfo.shared.profilPicture == nil{
            firebaseManager.getImageToFirebase(UserInfo.shared.stringUrl) { result in
                switch result{
                case .success(let profilPictureResult):
                    UserInfo.shared.addProfilPicture(profilPictureResult)
                    self.profilPicture.image = UserInfo.shared.profilPicture
                case .failure(_):
                    self.profilPicture.image = UIImage(systemName: "questionmark.circle.fill")!
                }
            }
        }
    }
    

}



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
