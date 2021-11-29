//
//  HomeViewController.swift
//  musicity
//
//  Created by Brian Friess on 20/11/2021.
//

import UIKit
import Firebase
import CoreLocation


class CreateProfilViewController: UIViewController, CLLocationManagerDelegate {

    let firebaseManager = FirebaseManager()
    let alerte = AlerteManager()
    let manager = CLLocationManager()
    
    @IBOutlet var customView: CustomCreateProfilView!
    
    @IBOutlet weak var infoLabelText: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var labelTextNumber: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var labelTextNbMember: UILabel!
    
        override func viewDidLoad() {
        
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
            
            
        customView.configureView()
            guard  let username = UserInfo.shared.publicInfo["\(DataBaseAccessPath.username)"] as? String else{
                return
            }
            infoLabelText.text = username
            
            switch UserInfo.shared.publicInfo["\(DataBaseAccessPath.BandOrMusician)"] as? String{
            case "Musician":
                customView.customStackIfItsBandOrMusician(.musician)
            case "Band":
                customView.customStackIfItsBandOrMusician(.band)
            default:
                return
            }
        }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
    }
    
    
    //we show the value in the label text "instrument"
    @IBAction func stepper(_ sender: UIStepper) {
        labelTextNumber.text = Int(sender.value).description
    }
    
    @IBAction func stepperBand(_ sender: UIStepper) {
        labelTextNbMember.text = Int(sender.value).description
    }
    
    
    
    
    //we configure the personals info if it's a musician profil
    //we configure also the musics info
    func configureMusicianProfile(){
        
        //we checl all the textField
        guard nameTextField.text != "", let firstname = nameTextField.text else {
            alerte.alerteVc(.emptyFirstname, self)
            return
        }
        guard lastNameTextField.text != "", let lastname = lastNameTextField.text else {
            alerte.alerteVc(.emptyLastename, self)
            return
        }
        guard ageTextField.text != "", let age = ageTextField.text else {
            alerte.alerteVc(.emptyAge, self)
            return
        }
        guard labelTextNumber.text != "instrument(s)", let nbInstrument = Int(labelTextNumber.text!) else{
            alerte.alerteVc(.emptyNbInstrument, self)
            return
        }

        //we create an array with the value in the textField
      let infoUser: [String : Any] = [
            "FirstName" : firstname,
            "LastName" : lastname,
            "Age" : age
        ]
        
        let infoMusicUser :  [String : Any] = [
            "NbInstrument" : nbInstrument
        ]
        
        //we give all the  personal value at the dataBase
        firebaseManager.setAndGetDictionnaryUserInfo(UserInfo.shared.userID, infoUser, .PersonalInfoUser) { result in
            switch result{
                case .success(let personalInfoResult):
                    UserInfo.shared.addPersonalInfo(personalInfoResult)
                   // UserInfo.shared.personalInfo = infoResult
                    self.firebaseManager.setAndGetDictionnaryUserInfo(UserInfo.shared.userID, infoMusicUser, .MusiqueInfoUser){ result in
                    switch result{
                        case .success(let resultInfo):
                        UserInfo.shared.addMusicInfo(resultInfo)
                        self.performSegue(withIdentifier: "goToSecondCreationProfil", sender: self)
                    case .failure(_):
                        self.alerte.alerteVc(.errorSetInfo, self)
                    }
                }
            case .failure(_):
                    self.alerte.alerteVc(.errorSetInfo, self)
            }
        }
    }
    
    
    
    
    func configureBandProfile(){
        
        guard labelTextNumber.text != "instrument(s)", let nbInstrument = Int(labelTextNumber.text!) else{
            alerte.alerteVc(.emptyNbInstrument, self)
            return
        }
        guard labelTextNbMember.text != "Membre du groupe", let nbMember = Int(labelTextNbMember.text!) else{
            alerte.alerteVc(.emptyNbMembre, self)
            return
        }
        
        let styleIndex = pickerView.selectedRow(inComponent: 0)
        let style = musicStyle[styleIndex]
        
        let infoMusicUser: [String : Any] = [
                "NbInstrument" : nbInstrument,
                "NbMember" : nbMember,
                "MusicStyle" : style
          ]
        
        firebaseManager.setAndGetDictionnaryUserInfo(UserInfo.shared.userID, infoMusicUser, .MusiqueInfoUser) { result in
            switch result{
            case .success(let resultInfo):
                UserInfo.shared.addMusicInfo(resultInfo)
                self.performSegue(withIdentifier: "goToSecondCreationProfil", sender: self)
            case .failure(_):
                self.alerte.alerteVc(.errorSetInfo, self)
            }
        }
    }
    
    
    @IBAction func pressNextButton(_ sender: UIButton){
        switch UserInfo.shared.publicInfo["\(DataBaseAccessPath.BandOrMusician)"] as? String{
        case "Musician":
            configureMusicianProfile()
        case "Band":
            configureBandProfile()
        default:
            return
        }
    }
    
    
    @IBAction func deconnexion(_ sender: Any) {
        firebaseManager.logOut { Result in
            switch Result{
            case .success(_):
                self.dismiss(animated: true, completion: nil)
            case .failure(_):
                self.alerte.alerteVc(.errorLogOut, self)
            }
        }
    }
}



//MARK: KeyBoard Manager
extension CreateProfilViewController : UITextFieldDelegate{
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        infoLabelText.resignFirstResponder()
        nameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        ageTextField.resignFirstResponder()
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        infoLabelText.resignFirstResponder()
        nameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        ageTextField.resignFirstResponder()
        return true
    }
}



//MARK: PickerView Manager
extension CreateProfilViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        musicStyle.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: musicStyle[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
    return attributedString
    }
    
    
}
