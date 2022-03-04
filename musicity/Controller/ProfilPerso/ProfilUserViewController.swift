//
//  ProfilUserViewController.swift
//  musicity
//
//  Created by Brian Friess on 30/11/2021.
//

import UIKit
import YoutubePlayer_in_WKWebView

final class ProfilUserViewController: UIViewController {

    @IBOutlet weak var profilPicture: UIImageView!
    @IBOutlet var profilUserView: ProfilPageView!
    @IBOutlet weak var usernameTextField: UILabel!
    @IBOutlet weak var youtubePlayer: WKYTPlayerView!
    @IBOutlet weak var nbMember: UILabel!
    
    private let firebaseManager = FirebaseManager()
    
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
    private func changeProfilPicture() {
        if profilPicture.image != UserInfo.shared.profilPicture {
            profilPicture.image = UserInfo.shared.profilPicture
        }
    }
    
    //check the informations for display the informations
    private func configureInformation() {
        if UserInfo.shared.checkIfItsBandOrMusician() == DataBaseAccessPath.band.returnAccessPath {
            profilUserView.isBandOrMusician(.isBand)
            nbMember.text = ("\(UserInfo.shared.publicInfoUser [DataBaseAccessPath.nbMember.returnAccessPath] as! String) membre(s)")
        } else {
            profilUserView.isBandOrMusician(.isMusician)
        }
        usernameTextField.text = UserInfo.shared.publicInfoUser[DataBaseAccessPath.username.returnAccessPath] as? String
    }
    
    // network call for display the profil picture 
    private func configureProfilPicture() {
        profilUserView.loadSpinner(.isInLoading)
        firebaseManager.getImageToFirebase(UserInfo.shared.stringUrl) { [weak self] result in
            guard let self = self else { return }
            switch result {
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
    private func youtubeVideoOrNot() {
        if UserInfo.shared.publicInfoUser[DataBaseAccessPath.youtubeUrl.returnAccessPath] as? String  == "" || UserInfo.shared.publicInfoUser[DataBaseAccessPath.youtubeUrl.returnAccessPath] == nil {
            profilUserView.youtubePlayerIsEmpty(.isEmpty)
        } else {
            profilUserView.youtubePlayerIsEmpty(.isNotEmpty)
            youtubePlayer.load(withVideoId: UserInfo.shared.publicInfoUser[DataBaseAccessPath.youtubeUrl.returnAccessPath] as! String)
        }
    }
    
    private func checkIfBioIsEmptyOrNot() {
        //we check if the bio is empty or not
        if UserInfo.shared.publicInfoUser[DataBaseAccessPath.bio.returnAccessPath] as? String  == "" || UserInfo.shared.publicInfoUser[DataBaseAccessPath.bio.returnAccessPath] == nil {
            profilUserView.bioIsEmpty(.isEmpty)
        } else {
            //if the bio isn't empty,  we write the bio in the label text
            profilUserView.bioLabelText.text = UserInfo.shared.publicInfoUser[DataBaseAccessPath.bio.returnAccessPath] as? String
        }
    }
}


// extension for the collection view
extension ProfilUserViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UserInfo.shared.instrumentFireBase.count + UserInfo.shared.styleFirbase.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewManager.tagCollectionCell.returnCellString, for : indexPath) as? TagCollectionViewCell else {
            return UICollectionViewCell()
        }
        // we check if we give the value of instruments or Style
        if indexPath.row < UserInfo.shared.instrumentFireBase.count {
            //at first, we give the value of instruments
            cell.tagLabel.text = UserInfo.shared.instrumentFireBase[indexPath.row]
        } else {
            //second, the style
            cell.tagLabel.text = UserInfo.shared.styleFirbase[indexPath.row - UserInfo.shared.instrumentFireBase.count]
        }
        return cell
    }
    
}
