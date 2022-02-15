//
//  TchatViewController.swift
//  musicity
//
//  Created by Brian Friess on 05/01/2022.
//


import UIKit
import IQKeyboardManagerSwift
import InputBarAccessoryView



class TchatViewController: UIViewController {


    @IBOutlet weak var tableView: UITableView!
    
    private let keyboardManager = KeyboardManager()
    private let inputBar = InputBarAccessoryView()
    private let firebaseManager = FirebaseManager()
    var currentUser = ResultInfo()
    private var messages = [[String:Any]]()
    private let alerte = AlerteManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(inputBar)
        getMessages()
        configureKeyboard()
        configureInputBar()
        configureKeyboardNotification()
       // removeNotificationToDataBase()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }

   /* func removeNotificationToDataBase(){
        firebaseManager.removeNotification(UserInfo.shared.userID, currentUser.userID)
    }*/
    
    func configureKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, tableView.contentInset == .zero {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height , right: 0)
        }
        scrollAtTheEndOfTableView()
    }


    @objc private func keyboardWillHide(notification: NSNotification) {
        tableView.contentInset = .zero
    }
    

    private func getMessages(){
        firebaseManager.readInMessengerDataBase(UserInfo.shared.userID, currentUser.userID) { result in
            switch result{
            case .success(let messages):
                self.messages.append(messages)
                self.tableView.insertRows(at: [IndexPath(row: self.messages.count-1, section: 0)], with: .automatic)
                self.scrollAtTheEndOfTableView()
            case .failure(_):
                break
            }
        }
    }
    
    
    func scrollAtTheEndOfTableView(){
        if messages.count != 0{
            let indexPath = IndexPath(row: (self.messages.count)-1 , section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
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
    
    
    private func configureKeyboard() {
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.enable = false
        keyboardManager.shouldApplyAdditionBottomSpaceToInteractiveDismissal = true
        keyboardManager.bind(inputAccessoryView: inputBar)
        keyboardManager.bind(to: tableView)
    }

    
    //before set the id of the user in our DDB, we check if he already exists
    private func checkIfUserAlreadyHere(_ user : ResultInfo) -> Bool{
        for currentUserId in UserInfo.shared.activeMessengerUserIdFirebase{
            if currentUserId == user.userID{
                return true
            }
        }
        return false
    }
    
    
    private func sendMessage(_ message: String?) {
        guard let message = message, !message.isEmpty else {
            return
        }
        guard let userName = UserInfo.shared.publicInfoUser[DataBaseAccessPath.username.returnAccessPath] else {
            return
        }
        let newMessage: [String:Any] = ["name": userName,
                                        "message": message]
        //we send the new message in our DDB
        firebaseManager.setNewMessage(UserInfo.shared.userID, currentUser.userID, newMessage) { [weak self] result in
            switch result{
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
    private func addNewUserIdInUserListMessenger(){
        if !self.checkIfUserAlreadyHere(currentUser){
            let countUserIdMessenger = UserInfo.shared.activeMessengerUserIdFirebase.count
            //we set our value in a dictionnary for set the DDB
            UserInfo.shared.activeMessengerUserId[String(countUserIdMessenger)] =  self.currentUser.userID
            //we add the new id in our DDB
            firebaseManager.setTheUserIdMessengerInDdb(UserInfo.shared.userID, UserInfo.shared.activeMessengerUserId) { result in
                switch result{
                case .success(_):
                    //we recover the new id in our Array in local
                    self.getTheUserIdFromDatabase()
                case .failure(_):
                    self.alerte.alerteVc(.messageError, self)
                }
            }
        }
    }
    
    
    private func getTheUserIdFromDatabase() {
        self.firebaseManager.getTheUserIdMessengerToDdb(UserInfo.shared.userID) { result in
            switch result{
            case .success(let userIdArray):
                self.addNewUserInTheOtherUserListMessenger()
                UserInfo.shared.addAllUserMessenger(userIdArray)
            case .failure(_):
                self.alerte.alerteVc(.messageError, self)
            }
        }
    }
    
    private func getANotificationInTheDDB(){
        firebaseManager.setNotification(currentUser.userID,UserInfo.shared.userID, ["Notification":UserInfo.shared.publicInfoUser[DataBaseAccessPath.username.returnAccessPath] as Any]) { result in
        }
    }
    
    
    
    //if we add the userId in the lise of messenger active in the UserInfo, we need to do the same thing in the currentUserResult
    private func addNewUserInTheOtherUserListMessenger(){
        //we get all the user in the messenger Id
        firebaseManager.getTheUserIdMessengerToDdb(currentUser.userID) { result in
            switch result{
            case .success(let arrayUser):
                //we create an array of user Id
                var arrayUserAndCurrentUserInfo = arrayUser
                arrayUserAndCurrentUserInfo.append(UserInfo.shared.userID)
                //we send the array firebase
                self.configureANewArrayUserInMessenger(arrayUserAndCurrentUserInfo)
                //if we don't have a userMessengerId in our database, we create an dictionnary just with the UserInfo
            case .failure(_):
                //we set the dictionnary in our database
                self.configureANewArrayUserInMessenger([UserInfo.shared.userID])
            }
        }
    }
    
    
    private func configureANewArrayUserInMessenger(_ arrayUser : [String]){
        self.currentUser.addAllUserMessenger(arrayUser)
        //we set the dictionnary in our database
        self.firebaseManager.setTheUserIdMessengerInDdb(self.currentUser.userID, self.currentUser.activeMessengerUserId) { result  in
            switch result{
                case .success(_):
                break
            case .failure(_):
                self.alerte.alerteVc(.messageError, self)
            }
        }
        
    }

}




extension TchatViewController :  UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellTchat", for : indexPath) as? TchatTableViewCell else {
            return UITableViewCell()
        }

        cell.messageLabel.text = messages[indexPath.row]["message"] as? String
        cell.nameLabel.text = messages[indexPath.row]["name"] as? String
        if cell.nameLabel.text == UserInfo.shared.publicInfoUser[DataBaseAccessPath.username.returnAccessPath] as? String{
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


//when we click on the sent button
extension TchatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        self.sendMessage(text)
        inputBar.inputTextView.text = ""
        inputBar.inputTextView.resignFirstResponder()
    }
}

