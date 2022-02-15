//
//  AppDelegate.swift
//  musicity
//
//  Created by Brian Friess on 19/11/2021.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import IQKeyboardManagerSwift
import InputBarAccessoryView


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var ref : DatabaseReference?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        configureIqKeyboard()
        FirebaseApp.configure()
        configureFirbaseEmulators()
        return true
    }
    
    
    
    
    func configureFirbaseEmulators(){
        #if EMULATORS
        print(
        """
        ****************************
        Emulator
        ****************************
        """
        )
        Storage.storage().useEmulator(withHost:"localhost", port:9199)
        Auth.auth().useEmulator(withHost:"localhost", port:9099)
        ref = Database.database(url:"http://localhost:9000?ns=musicity-ff6d8").reference()
        
        #elseif DEBUG
        
        print(
        """
        ****************************
        DEBUG
        ****************************
        """)
        ref = Database.database(url: "https://musicity-ff6d8-default-rtdb.europe-west1.firebasedatabase.app").reference()
        #endif
    }
    
    
    
    private func configureIqKeyboard(){
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.toolbarTintColor = .label
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 60
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }

    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // set orientations you want to be allowed in this property by default
    var orientationLock = UIInterfaceOrientationMask.all

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
            return self.orientationLock
    }

    
}

struct AppUtility {

    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
    
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }

    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
   
        self.lockOrientation(orientation)
    
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }

}

