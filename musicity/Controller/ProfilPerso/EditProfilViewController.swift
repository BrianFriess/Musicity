//
//  EditProfilViewController.swift
//  musicity
//
//  Created by Brian Friess on 10/12/2021.
//

import UIKit
import PhotosUI

final class EditProfilViewController: UIViewController {

    @IBOutlet var editUserView: EditProfilCustomView!
    @IBOutlet weak var bioLabel: UITextView!
    @IBOutlet weak var youtubeTextField: UITextField!

    private let youtubeManager = YoutubeManager(session: URLSession(configuration: .default))
    private let alert = AlertManager()
    private let fireBaseManager = FirebaseManager()
    private let imagePicker = ImagePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editUserView.configure(UserInfo.shared.profilPicture!)
        checkIfBioIsEmptyOrNotAtStart()
        checkIfYoutubeLinkIsEmptyOrNot()
    }

    //we check if the bio is empty or not in our segue
    private func checkIfBioIsEmptyOrNotAtStart() {
        if UserInfo.shared.publicInfoUser[DataBaseAccessPath.bio.returnAccessPath] as? String == "" || UserInfo.shared.publicInfoUser[DataBaseAccessPath.bio.returnAccessPath] == nil {
            editUserView.bioIsEmpty(.isEmpty)
        } else {
            editUserView.bioLabelText.text = UserInfo.shared.publicInfoUser[DataBaseAccessPath.bio.returnAccessPath] as? String
        }
    }
    
    //we check if the youtube link is empty or not in our segue
    private func checkIfYoutubeLinkIsEmptyOrNot() {
        if  UserInfo.shared.publicInfoUser[DataBaseAccessPath.youtubeUrl.returnAccessPath] != nil {
            editUserView.youtubeUrlLabel.text = ("https://www.youtube.com/watch?v=\(String(describing: UserInfo.shared.publicInfoUser[DataBaseAccessPath.youtubeUrl.returnAccessPath] as! String))")
        }
    }
    
    //we check if bio is empty when we push save, if yes, we give the value in our dataBase
    private func checkIfBioIsEmptyOrNotWhenWePushSave() {
        fireBaseManager.setAndGetSingleUserInfo(UserInfo.shared.userID, editUserView.bioLabelText.text, .publicInfoUser, .bio) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let bio):
                UserInfo.shared.publicInfoUser[DataBaseAccessPath.bio.returnAccessPath]  = bio
            case .failure(_):
                self.alert.alertVc(.errorSetInfo, self)
            }
        }
    }
    
    //we check if we have an url in the youtube Text Field
    private func checkIfYoutubeUrlIsEmpty() {
        if youtubeTextField.text != "" && youtubeTextField.text != nil {
            //if yes, we check if it's a right youtube url
            youtubeManager.checkYoutubeLink(youtubeTextField.text!) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let url):
                        //if yes, we get the youtube URL in our Database
                    self.getTheYoutubeUrlInDDB(url)
                case .failure(_):
                    self.alert.alertVc(.youtubeLink, self)
                }
            }
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    //we get the url of the video in Firebase
    private func getTheYoutubeUrlInDDB(_ url : String) {
        self.fireBaseManager.setAndGetSingleUserInfo(UserInfo.shared.userID, url, .publicInfoUser, .youtubeUrl) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let urlSuffix):
                UserInfo.shared.publicInfoUser[DataBaseAccessPath.youtubeUrl.returnAccessPath] = urlSuffix
                self.dismiss(animated: true, completion: nil)
            case .failure(_):
                self.alert.alertVc(.youtubeLink, self)
            }
        }
    }
    
    //we call the function for call our network call and dismiss the page
    @IBAction func pushSaveBUtton(_ sender: Any) {
        if editUserView.bioLabelText.text.count < 1500 {
            checkIfBioIsEmptyOrNotWhenWePushSave()
            checkIfYoutubeUrlIsEmpty()
        } else {
            alert.alertVc(.tooMuchCara, self)
        }
    }
    
    //we call the function who call the function displayPhotoLibrary
    @IBAction func pressPhotoButton(_ sender: Any) {
    //we check if we can use the photoLibrary
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            switch status {
            case .notDetermined, .restricted, .denied, .limited:
                DispatchQueue.main.async {
                self.alert.alertVc(.cantAccessPhotoLibrary, self)
                }
            case .authorized:
                DispatchQueue.main.async {
                    self.displayPhotoLibrary()
                }
            @unknown default:
                DispatchQueue.main.async {
                self.alert.alertVc(.cantAccessPhotoLibrary, self)
                }
            }
        }
    }
    
}


extension EditProfilViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //we create this function  for create an ImagePickerController and display the photoLibrary
   private func displayPhotoLibrary() {
       imagePicker.displayPhotoLibrary(self)
    }

    //we display a new profil picture and we add the picture in our segue
    private func displayProfilPictureAndAddInTheSegue(_ profilPicture : UIImage) {
        self.editUserView.profilPicture.setImage(profilPicture, for: .normal)
        self.editUserView.profilPicture.imageView?.contentMode = .scaleAspectFill
        self.editUserView.profilPicture.clipsToBounds = true
        UserInfo.shared.profilPicture = profilPicture
        self.editUserView.loadPhoto(.isLoad)
    }
    
    //this function is for choose one picture in the photo Library
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //if we choose an image, the image of chooseButton changes
        self.editUserView.loadPhoto(.isloading)
        guard let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        guard let imageData = pickedImage.pngData() else {
            return
        }
        //we set the profilPicture in firebase and we get the url in our Segue
        fireBaseManager.setImageInFirebaseAndGetUrl(UserInfo.shared.userID, imageData) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let urlImage):
                UserInfo.shared.addUrlString(urlImage)
                self.fireBaseManager.getImageToFirebase(urlImage) { [weak self] imageResult in
                    guard let self = self else { return }
                    switch imageResult {
                    case .success(let profilPicture):
                        //we display a new profil picture and we add the picture in our segue
                        self.displayProfilPictureAndAddInTheSegue(profilPicture)
                    case .failure(_):
                        self.alert.alertVc(.errorImage, self)
                        self.editUserView.loadPhoto(.isLoad)
                    }
                }
            case .failure(_):
                self.alert.alertVc(.errorImage, self)
                self.editUserView.loadPhoto(.isLoad)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.editUserView.loadPhoto(.isLoad)
        dismiss(animated: true, completion: nil)
    }
    
}


//MARK: KeyBoard Manager
extension EditProfilViewController : UITextFieldDelegate {
    
    //dismiss Keyboard when we click on the screen
    @IBAction func dismissKeyboard(_ sender: Any) {
        youtubeTextField.resignFirstResponder()
        bioLabel.resignFirstResponder()
    }

    //dismiss keyboard when we click on "enter"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        youtubeTextField.resignFirstResponder()
        bioLabel.resignFirstResponder()
        return true
    }
    
}
