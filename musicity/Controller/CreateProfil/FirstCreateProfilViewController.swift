//
//  FirstCreateProfilViewController.swift
//  musicity
//
//  Created by Brian Friess on 08/12/2021.
//

import UIKit

class FirstCreateProfilViewController: UIViewController {

    @IBOutlet weak var collectionStyle: UICollectionView!

    var isSelectArray = Array(repeating: false,  count: musicStyle.count)
    var alerte = AlerteManager()
    var dictStyle = [Int : String]()
    var fireBaseManager = FirebaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
 
    
    @IBAction func pressNextButton(_ sender: Any) {
        UserInfo.shared.addStyle(dictStyle)
        UserInfo.shared.checkStyle(dictStyle.count, dictStyle)
        
        //we check if the user have choice one style or more
        guard UserInfo.shared.checkIfStyleIsEmpty() else {
            alerte.alerteVc(.emptyStyle, self)
            return
        }
        
        fireBaseManager.setDictionnaryUserInfo(UserInfo.shared.userID, UserInfo.shared.style, .Style) { result in
            switch result{
            case .success(_):
                self.performSegue(withIdentifier: "goToChoiceInstruSegue", sender: self)
            case .failure(_):
                self.alerte.alerteVc(.errorSetInfo, self)
            }
        }
    }
    

    
}



extension FirstCreateProfilViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return musicStyle.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "styleTagCell", for : indexPath) as? ChoiceCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.selectCell(isSelectArray[indexPath.row])
        cell.tagLabel.text = musicStyle[indexPath.row]
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isSelectArray[indexPath.row] == false{
            isSelectArray[indexPath.row] = true
            dictStyle[indexPath.row] = musicStyle[indexPath.row]
        } else {
            isSelectArray[indexPath.row] = false
            dictStyle[indexPath.row] = nil
        }
       collectionStyle.reloadItems(at: [indexPath])
    }
    
    
    
}
