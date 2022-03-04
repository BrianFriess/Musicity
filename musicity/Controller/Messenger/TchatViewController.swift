//
//  TchatViewController.swift
//  musicity
//
//  Created by Brian Friess on 05/01/2022.
//


import UIKit
import IQKeyboardManagerSwift
import InputBarAccessoryView

final class TchatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let keyboardManager = KeyboardManager()
    private let inputBar = InputBarAccessoryView()
    private let firebaseManager = FirebaseManager()
    private let alert = AlertManager()
    
    var currentUser = ResultInfo()
    
    private var messages = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(inputBar)
        getMessages()
        configureKeyboard()
        configureInputBar()
        configureKeyboardNotification()
        checkIfWeHaveAnewNotificationForRemove()
    }
    
    //when view disappear, we reactivate the package IQKeyboardManager
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        firebaseManager.removeNotificationUserObserver(UserInfo.shared.userID)
    }

    //delete the notification when view did load
    private func removeNotificationToDataBase() {
        firebaseManager.removeNotificationUser(UserInfo.shared.userID, currentUser.userID)
        currentUser.haveNotification = false
    }
    
    //if we receive a tchat in the tchatViewConroller, we delete the notification
    private func checkIfWeHaveAnewNotificationForRemove() {
        firebaseManager.checkNewUserNotification(UserInfo.shared.userID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let userId):
                print(userId)
                if userId[DataBaseAccessPath.notification.returnAccessPath] as! String == self.currentUser.userID {
                self.removeNotificationToDataBase()
                }
            case .failure(_):
                break
            }
        }
    }
    
    //we configure the Keyboard for 
    private func configureKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //when the keyboard appear
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, tableView.contentInset == .zero {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height , right: 0)
        }
        scrollAtTheEndOfTableView()
    }

    //when the keyboard disepear
    @objc private func keyboardWillHide(notification: NSNotification) {
        tableView.contentInset = .zero
    }
    
    //display the new message
    private func getMessages() {
        firebaseManager.readInMessengerDataBase(UserInfo.shared.userID, currentUser.userID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let messages):
                self.messages.append(messages)
                self.tableView.insertRows(at: [IndexPath(row: self.messages.count-1, section: 0)], with: .automatic)
                self.scrollAtTheEndOfTableView()
            case .failure(_):
                break
            }
        }
    }
    
    //thanks to this function, we scroll at the end of the tchat tableView
    private func scrollAtTheEndOfTableView() {
        if messages.count != 0 {
            let indexPath = IndexPath(row: (self.messages.count)-1 , section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    //we configure the input bar at the bottom
    private func configureInputBar() {
        inputBar.delegate = self
        inputBar.inputTextView.isImagePasteEnabled = false
        inputBar.isTranslucent = true
        inputBar.backgroundView.backgroundColor = .tertiarySystemBackground
        inputBar.translatesAutoresizingMaskIntoConstraints = false
        
        let inputTextView = inputBar.inputTextView
        inputTextView.layer.cornerRadius = 14.0
        inputTextView.layer.borderWidth = 0.0
        inputTextView.backgroundColor = .secondarySystemGroupedBackground
        inputTextView.font = .systemFont(ofSize: 18.0)
        inputTextView.placeholderLabel.text = "Votre message"
        inputTextView.textContainerInset = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 6, left: 18, bottom: 6, right: 15)
        
        let sendButton = inputBar.sendButton
        sendButton.image = UIImage(systemName: "paperplane.fill")
        sendButton.tintColor = .label
        sendButton.title = nil
        sendButton.setSize(CGSize(width: 30, height: 30), animated: true)
    }
    
    //we reconfigure the keyboard for don't use the package IQKeyboardManager in this controller
    private func configureKeyboard() {
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.enable = false
        keyboardManager.shouldApplyAdditionBottomSpaceToInteractiveDismissal = true
        keyboardManager.bind(inputAccessoryView: inputBar)
        keyboardManager.bind(to: tableView)
    }

    //before set the id of the user in our DDB, we check if he already exists
    private func checkIfUserAlreadyHere(_ user : ResultInfo) -> Bool {
        for currentUserId in UserInfo.shared.activeMessengerUserIdFirebase {
            if currentUserId == user.userID {
                return true
            }
        }
        return false
    }
    
    //when we send a new message, we check if we have all the info
    private func sendMessage(_ message: String?) {
        guard let message = message, !message.isEmpty else {
            return
        }
        guard let userName = UserInfo.shared.publicInfoUser[DataBaseAccessPath.username.returnAccessPath] else {
            return
        }
        //create a dictionnay for firebase
        let newMessage: [String:Any] = ["name": userName,
                                        "message": message]
        //we send the new message in our DDB
        firebaseManager.setNewMessage(UserInfo.shared.userID, currentUser.userID, newMessage) { [weak self] result in
            switch result {
            case .success(_):
                self?.inputBar.inputTextView.text = ""
                self?.inputBar.inputTextView.resignFirstResponder()
                self?.scrollAtTheEndOfTableView()
                self?.addNewUserIdInUserListMessenger()
                self?.getANotificationInTheDDB()
            case .failure(_):
                break
            }
        }
    }
    
    //if the userId is not in our DDB, we create a new value in our DDB and we recover this value in our array of UserIdMessenger
    private func addNewUserIdInUserListMessenger() {
        if !self.checkIfUserAlreadyHere(currentUser) {
            let countUserIdMessenger = UserInfo.shared.activeMessengerUserIdFirebase.count
            //we set our value in a dictionnary for set the DDB
            UserInfo.shared.activeMessengerUserId[String(countUserIdMessenger)] =  self.currentUser.userID
            //we add the new id in our DDB
            firebaseManager.setTheUserIdMessengerInDdb(UserInfo.shared.userID, UserInfo.shared.activeMessengerUserId) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(_):
                    //we recover the new id in our Array in local
                    self.getTheUserIdFromDatabase()
                case .failure(_):
                    self.alert.alertVc(.messageError, self)
                }
            }
        }
    }
    
    //recover the userId of the other user
    private func getTheUserIdFromDatabase() {
        self.firebaseManager.getTheUserIdMessengerToDdb(UserInfo.shared.userID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let userIdArray):
                self.addNewUserInTheOtherUserListMessenger()
                UserInfo.shared.addAllUserMessenger(userIdArray)
            case .failure(_):
                self.alert.alertVc(.messageError, self)
            }
        }
    }
    
    //add a notification in ddb
    private func getANotificationInTheDDB() {
        firebaseManager.setNotificationBanner(currentUser.userID,UserInfo.shared.userID, [DataBaseAccessPath.notificationBanner.returnAccessPath : UserInfo.shared.publicInfoUser[DataBaseAccessPath.username.returnAccessPath] as Any]) { _ in
        }
        firebaseManager.setNewUserNotification(currentUser.userID, UserInfo.shared.userID) { _ in
        }
    }
    
    //if we add the userId in the lise of messenger active in the UserInfo, we need to do the same thing in the currentUserResult
    private func addNewUserInTheOtherUserListMessenger() {
        //we get all the user in the messenger Id
        firebaseManager.getTheUserIdMessengerToDdb(currentUser.userID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let arrayUser):
                //we create an array of user Id
                var arrayUserAndCurrentUserInfo = arrayUser
                arrayUserAndCurrentUserInfo.append(UserInfo.shared.userID)
                //we send the array firebase
                self.configureANewArrayUserInMessenger(arrayUserAndCurrentUserInfo)
                //if we don't have a userMessengerId in our database, we create an dictionnary just with the UserInfo
            case .failure(_):
                //we set the array in our database
                self.configureANewArrayUserInMessenger([UserInfo.shared.userID])
            }
        }
    }
    
    //we send the array firebase
    private func configureANewArrayUserInMessenger(_ arrayUser : [String]) {
        self.currentUser.addAllUserMessenger(arrayUser)
        //we set the dictionnary in our database
        self.firebaseManager.setTheUserIdMessengerInDdb(self.currentUser.userID, self.currentUser.activeMessengerUserId) { [weak self] result  in
            guard let self = self else { return }
            switch result {
                case .success(_):
                break
            case .failure(_):
                self.alert.alertVc(.messageError, self)
            }
        }
    }

    //we prepare the segue
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == SegueManager.segueToViewProfilInMessenger.returnSegueString {
            let successVC = segue.destination as! ResultUserProfilViewController
            successVC.currentUser = currentUser
            successVC.isAfterTchat = true
        }
    }
    
    @IBAction func tapProfilButton(_ sender: Any) {
        performSegue(withIdentifier: SegueManager.segueToViewProfilInMessenger.returnSegueString, sender: self)
    }
    
}


extension TchatViewController :  UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewManager.cellTchat.returnCellString, for : indexPath) as? TchatTableViewCell else {
            return UITableViewCell()
        }
        cell.messageLabel.text = messages[indexPath.row]["message"] as? String
        cell.nameLabel.text = messages[indexPath.row]["name"] as? String
        if cell.nameLabel.text == UserInfo.shared.publicInfoUser[DataBaseAccessPath.username.returnAccessPath] as? String {
            cell.viewCustom.backgroundColor = UIColor.systemOrange
        } else {
            cell.viewCustom.backgroundColor = UIColor.gray
        }
        return cell
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}


extension TchatViewController: InputBarAccessoryViewDelegate {
    //when we click on the sent button
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        self.sendMessage(text)
        inputBar.inputTextView.text = ""
        inputBar.inputTextView.resignFirstResponder()
    }
    
}

