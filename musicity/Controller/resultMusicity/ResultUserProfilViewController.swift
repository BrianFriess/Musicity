//
//  ViewUserProfilViewController.swift
//  musicity
//
//  Created by Brian Friess on 06/12/2021.
//

import UIKit
import YoutubePlayer_in_WKWebView

final class ResultUserProfilViewController: UIViewController {
    
    @IBOutlet weak var tagResultCollection: UICollectionView!
    @IBOutlet var customeResultProfilPageView: ResultProfilPage!
    
    private let firebaseManager = FirebaseManager()
    private let alertManager = AlertManager()
    
    var currentUser = ResultInfo()
    var isAfterTchat = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    //we use this function for configure the view with all the info in the model
    private func configureView() {
        checkIfProfilPictureIsAlreadyLoad()
        checkIfBioIsEmpty()
        customeResultProfilPageView.configLabelUsername(currentUser.publicInfoUser[DataBaseAccessPath.username.returnAccessPath] as! String)
        bandOrMusician()
        youtubeVideoOrNot()
        hideContactButtonOrNot()
    }
    
    //if before this controller the user is in the tchat, we hide the "contact" button 
    private func hideContactButtonOrNot() {
        if isAfterTchat {
            customeResultProfilPageView.contactButton.isHidden = true
        }
    }

    //we check if it's band or musician profil
    private func bandOrMusician() {
        if currentUser.checkIfItsBandOrMusician() == DataBaseAccessPath.band.returnAccessPath {
            customeResultProfilPageView.isBandOrMusician(.isBand)
            customeResultProfilPageView.nbMemberLabel.text = ("\(currentUser.publicInfoUser[DataBaseAccessPath.nbMember.returnAccessPath] as! String) membre(s)")
        } else {
            customeResultProfilPageView.isBandOrMusician(.isMusician)
        }
    }
    
    //we check if the user have already a youtubeVideo
    private func youtubeVideoOrNot() {
        if currentUser.publicInfoUser[DataBaseAccessPath.youtubeUrl.returnAccessPath] as? String == "" || currentUser.publicInfoUser[DataBaseAccessPath.youtubeUrl.returnAccessPath] == nil {
            customeResultProfilPageView.youtubePlayerIsEmpty(.isEmpty)
        } else {
            customeResultProfilPageView.youtubePlayerIsEmpty(.isNotEmpty)
            customeResultProfilPageView.youtubePlayer.load(withVideoId: currentUser.publicInfoUser[DataBaseAccessPath.youtubeUrl.returnAccessPath] as! String)
        }
    }
    
    //we check if the profilPicture is already load in the front page, if not, we use our network call for display the profil picture
    private func checkIfProfilPictureIsAlreadyLoad() {
        if currentUser.profilPicture == nil {
            customeResultProfilPageView.loadSpinner(.isInLoading)
            firebaseManager.getImageToFirebase( currentUser.stringUrl) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let image):
                    self.customeResultProfilPageView.loadSpinner(.isLoad)
                    self.customeResultProfilPageView.profilPicture.image = image
                case .failure(_):
                    self.alertManager.alertVc(.errorImage, self)
                    self.customeResultProfilPageView.loadSpinner(.isLoad)
                }
            }
        } else {
            customeResultProfilPageView.profilPicture.image = currentUser.profilPicture
        }
    }
    
    //we check the user have already a bio
    private func checkIfBioIsEmpty() {
        if currentUser.publicInfoUser[DataBaseAccessPath.bio.returnAccessPath] as? String == "" || currentUser.publicInfoUser[DataBaseAccessPath.bio.returnAccessPath] == nil {
            customeResultProfilPageView.bioIsEmpty(.isEmpty)
        } else {
            customeResultProfilPageView.bioIsEmpty(.isNotEmpty)
            customeResultProfilPageView.bioLabelText.text = currentUser.publicInfoUser[DataBaseAccessPath.bio.returnAccessPath] as? String
        }
    }
    
    //we prepare the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueManager.segueToFirstTimeMessenger.returnSegueString {
            let successVC = segue.destination as! TchatViewController
            successVC.currentUser = currentUser
        }
    }
    
    //we open the tchat View Controller
    @IBAction func contactButton(_ sender: Any) {
       performSegue(withIdentifier: SegueManager.segueToFirstTimeMessenger.returnSegueString, sender: self)
    }
    
}


extension ResultUserProfilViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentUser.instrumentFireBase.count + currentUser.styleFirbase.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewManager.tagCollectionResultCell.returnCellString, for : indexPath) as? TagCollectionViewCell else {
            return UICollectionViewCell()
        }
        // we check if we give the value of instruments or Style
        if indexPath.row < currentUser.instrumentFireBase.count {
            //at first, we give the value of instruments
            cell.tagLabel.text = currentUser.instrumentFireBase[indexPath.row]
        } else {
            //second, the style
            cell.tagLabel.text = currentUser.styleFirbase[indexPath.row - currentUser.instrumentFireBase.count]
        }
        return cell
    }
    
}




