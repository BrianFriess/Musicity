//
//  FirstCreateProfilViewController.swift
//  musicity
//
//  Created by Brian Friess on 08/12/2021.
//

import UIKit

final class FirstCreateProfilViewController: UIViewController {
    
    @IBOutlet weak var collectionStyle: UICollectionView!
    
    private var isSelectArray = Array(repeating: false,  count: musicStyle.count)
    private var dictStyle = [Int : String]()
    
    private let fireBaseManager = FirebaseManager()
    private let alert = AlertManager()
    
    //when we press on the next button
    @IBAction func pressNextButton(_ sender: Any) {
        UserInfo.shared.addStyle(dictStyle)
        UserInfo.shared.checkStyle(dictStyle.count, dictStyle)
        //we check if the user have choice one style or more
        guard UserInfo.shared.checkIfStyleIsEmpty() else {
            alert.alertVc(.emptyStyle, self)
            return
        }
        //we set a dictionnay with the choice style in firebase
        setStyleInDDB()
    }
    
    //we set a dictionnay with the choive style in firebase
    private func setStyleInDDB() {
        fireBaseManager.setDictionnaryUserInfo(UserInfo.shared.userID, UserInfo.shared.style, .style) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.performSegue(withIdentifier: SegueManager.goToChoiceInstruSegue.returnSegueString, sender: self)
            case .failure(_):
                self.alert.alertVc(.errorSetInfo, self)
            }
        }
    }
    
}


extension FirstCreateProfilViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return musicStyle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewManager.styleTagCell.returnCellString, for : indexPath) as? ChoiceCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.selectCell(isSelectArray[indexPath.row])
        cell.tagLabel.text = musicStyle[indexPath.row]
        return cell
    }
    
    //when we select an item, if the value of the item is true, after the click, the value is false and if the value is false after the click, is true
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isSelectArray[indexPath.row] == false {
            isSelectArray[indexPath.row] = true
            dictStyle[indexPath.row] = musicStyle[indexPath.row]
        } else {
            isSelectArray[indexPath.row] = false
            dictStyle[indexPath.row] = nil
        }
        collectionStyle.reloadItems(at: [indexPath])
    }
    
}
