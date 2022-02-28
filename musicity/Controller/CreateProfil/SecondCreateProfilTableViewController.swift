//
//  SecondCreateProfilTableViewController.swift
//  musicity
//
//  Created by Brian Friess on 09/12/2021.
//

import UIKit
import PhotosUI

class SecondCreateProfilTableViewController: UIViewController {

    @IBOutlet var customView: CustomCreateSecondUIView!
    @IBOutlet weak var collectionInstrument: UICollectionView!
    @IBOutlet weak var nbMemberLabel: UILabel!
    @IBOutlet weak var photoButton: UIButton!
    
    private var isSelectArray = Array(repeating: false,  count: musicInstruments.count)
    private var dictInstrument = [Int : String]()
    private let alerte = AlerteManager()
    private let fireBaseManager = FirebaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //call the function in the customView
        customView.configView()
        
        //check if it's a band or musician for configure the view
        if UserInfo.shared.checkIfItsBandOrMusician() == "Band" {
            customView.customStack(.band)
        } else {
            customView.customStack(.musician)
        }
    }
    
    
    @IBAction func pressFinishButton(_ sender: Any) {
        UserInfo.shared.addInstrument(dictInstrument)
        UserInfo.shared.checkInstrument(dictInstrument.count, dictInstrument)
        
        //we check if wa have all informations
        guard UserInfo.shared.checkUrlProfilPicture() else {
            alerte.alerteVc(.emptyProfilPicture, self)
            return
        }
        
        guard UserInfo.shared.checkIfInstrumentIsEmpty() else{
            alerte.alerteVc(.emptyInstrument, self)
            return
        }
        
        //we check if it's band or musician
        if UserInfo.shared.checkIfItsBandOrMusician() == "Band"{
            //check if the label nbMember is not empty
            guard nbMemberLabel.text != "Membre(s)" else {
                alerte.alerteVc(.emptyNbMembre, self)
                return
            }
            bandOrMusician()
        }
        //we set a dictionnary with all the instruments in firebase
        setInstrumentInDDB()
    }
    
    
    
    //we check if it's band or musician
    private func bandOrMusician(){
        //if it's a band, we set the number of member in the band in firebase
        fireBaseManager.setSingleUserInfo(UserInfo.shared.userID, .publicInfoUser, .NbMember, nbMemberLabel.text!) { result in
            switch result{
            case .success(_):
                break
            case .failure(_):
                self.alerte.alerteVc(.emptyNbMembre, self)
            }
        }
    }
    
    
    //we set a dictionnary with all the instruments in firebase
    private func setInstrumentInDDB(){
        fireBaseManager.setDictionnaryUserInfo( UserInfo.shared.userID, UserInfo.shared.instrument, .Instrument) { result in
            switch result{
            case .success(_):
                self.performSegue(withIdentifier: "goToWelcomeSegue", sender: self)
            case .failure(_):
                self.alerte.alerteVc(.errorSetInfo, self)
            }
        }
    }
    
    
    //set the value thanks to the stepper
    @IBAction func stepperBand(_ sender: UIStepper) {
        nbMemberLabel.text = Int(sender.value).description
        if Int(sender.value) == 0{
            nbMemberLabel.text = "Membre(s)"
        }
    }
    
    
    //we call the function who call the function displayPhotoLibrary
    @IBAction func pressPhotoButton(_ sender: Any) {
    //we check if we can use the photoLibrary
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            switch status {
            case .notDetermined:
                DispatchQueue.main.async {
                self.alerte.alerteVc(.cantAccessPhotoLibrary, self)
                }
            case .restricted:
                DispatchQueue.main.async {
                self.alerte.alerteVc(.cantAccessPhotoLibrary, self)
                }
            case .denied:
                DispatchQueue.main.async {
                self.alerte.alerteVc(.cantAccessPhotoLibrary, self)
                }
            case .authorized:
                DispatchQueue.main.async {
                    self.displayPhotoLibrary()
                }
            case .limited:
                DispatchQueue.main.async {
                self.alerte.alerteVc(.cantAccessPhotoLibrary, self)
                }
            @unknown default:
                DispatchQueue.main.async {
                self.alerte.alerteVc(.cantAccessPhotoLibrary, self)
                }
            }
        }
    }

}



extension SecondCreateProfilTableViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //we create this function  for create an ImagePickerController and display the photoLibrary
    private func displayPhotoLibrary(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        //we choose as source the photo library
        imagePicker.sourceType = .photoLibrary
        //we open the photo Library
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //we add the picture in the segue and we display the picture when she's load
    private func displayProfilPictureAndAddInTheSegue(_ urlImage : String,_ imageData : Data){
        UserInfo.shared.addUrlString(urlImage)
        self.photoButton.setImage(UIImage(data: imageData), for: .normal)
        self.photoButton.imageView?.contentMode = .scaleAspectFill
        self.photoButton.clipsToBounds = true
        self.customView.loadPhoto(.isLoad)
    }
    
    //this function is for choose one picture in the photo Library
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //if we choose an image, the image of chooseButton changes
        self.customView.loadPhoto(.isloading)
        guard let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{
            return
        }
        guard let imageData = pickedImage.pngData() else {
            return
        }
        
        //we set the profilPicture in firebase and we get the url in our Segue
        fireBaseManager.setImageInFirebaseAndGetUrl(UserInfo.shared.userID, imageData) { result in
            switch result{
            case .success(let urlImage):
                //we add the picture in the segue and we display the picture when she's load 
                self.displayProfilPictureAndAddInTheSegue(urlImage , imageData)
            case .failure(_):
                self.alerte.alerteVc(.errorImage, self)
                self.customView.loadPhoto(.isLoad)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.customView.loadPhoto(.isLoad)
        dismiss(animated: true, completion: nil)
    }
    
}




//this extension is for our collectionView
extension SecondCreateProfilTableViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    
    //return the number of music instruments
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return musicInstruments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //custom cell
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "instrumentTagCell", for : indexPath) as? ChoiceCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        //check if the cell is select or not
        cell.selectCell(isSelectArray[indexPath.row])
        cell.tagLabel.text = musicInstruments[indexPath.row]
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //when the user push on one cell, we check if the cell is select or desect
        if isSelectArray[indexPath.row] == false{
            isSelectArray[indexPath.row] = true
            dictInstrument[indexPath.row] = musicInstruments[indexPath.row]
        } else {
            isSelectArray[indexPath.row] = false
            dictInstrument[indexPath.row] = nil
        }
        //reload the cell
       collectionInstrument.reloadItems(at: [indexPath])
    }
    
}
