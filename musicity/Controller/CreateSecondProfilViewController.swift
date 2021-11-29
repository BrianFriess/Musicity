//
//  CreateSecondProfilViewController.swift
//  musicity
//
//  Created by Brian Friess on 26/11/2021.
//

import UIKit
import Firebase
import FirebaseStorage
import PhotosUI
import SwiftUI


class CreateSecondProfilViewController: UIViewController {
    
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet var customView: CustomSecondCreateProfil!
    @IBOutlet weak var tableView: UITableView!
    
    
    let fireBaseManager = FirebaseManager()
    let alerte = AlerteManager()
    //this variable is use in our segue in our tableView
    var row = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customView.configureButton()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
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
    
    @IBAction func finishButton(_ sender: UIButton) {
        
        guard UserInfo.shared.checkAllTheInstruments()else{
            alerte.alerteVc(.emptyInstrument, self)
            return
        }
        
        guard UserInfo.shared.checkProfilPicture() else{
            alerte.alerteVc(.emptyProfilPicture, self)
            return
        }
            
        fireBaseManager.setDictionnaryUserInfo(UserInfo.shared.userID, UserInfo.shared.instrument, .Instrument) { result in
            switch result{
            case .success(_):
                self.fireBaseManager.getDictionnaryInstrumentToFirebase(UserInfo.shared.userID, .Instrument) { Result in
                    switch Result{
                    case .success(let resultInstru):
                        UserInfo.shared.addAllInstrument(resultInstru)
                        self.performSegue(withIdentifier: "goToWelcomeSegue", sender: nil)
                    case .failure(_):
                        self.alerte.alerteVc(.errorSetInfo, self)
                    }
                }
            case .failure(_):
                self.alerte.alerteVc(.errorSetInfo, self)
            }
        }
    }
    
    
}






//this extension is for choose a photo in photo library and save the photo in Firebase
extension CreateSecondProfilViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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
    
    //this function is for choose one picture in the photo Library
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //if we choose an image, the image of chooseButton changes
        self.customView.loadPhoto(.isloading)
        guard let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{
            return
        }
        guard let imageData = pickedImage.pngData()else{
            return
        }
        //we calle the function for set an image in Firebase and we get the image in our button
        fireBaseManager.SetAndGetImageToFirebase(imageData) { result in
            switch result{
            case .success(let image):
                UserInfo.shared.addProfilPicture(image)
                self.photoButton.setImage(image, for: .normal)
                self.photoButton.imageView?.contentMode = .scaleAspectFill
                self.photoButton.clipsToBounds = true
                self.customView.loadPhoto(.isLoad)
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



//we create the tableView in this extension
extension CreateSecondProfilViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserInfo.shared.musicInfoUser["\(DataBaseAccessPath.NbInstrument)"] as! Int
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "infoUserCell", for: indexPath) as? InfoUserCellTableViewCell else{
            return UITableViewCell()
        }
        //we use this variable for read in our dictionnary 
        let rowString = String(indexPath.row)
        guard UserInfo.shared.instrument[rowString] != nil else{
            cell.labelTextInstrument.text = "Ajouter un instrument"
            return cell
        }
        cell.labelTextInstrument.text = UserInfo.shared.instrument[rowString] as? String
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToChooseIntrument"{
            let successVC = segue.destination as! InstrumentViewController
            successVC.row = row
        }
    }
    
    //we call the segue for choose an instrument
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        row = indexPath.row
        self.performSegue(withIdentifier: "goToChooseIntrument", sender: nil)
    }
}
