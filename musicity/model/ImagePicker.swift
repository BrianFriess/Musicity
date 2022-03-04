//
//  ImagePicker.swift
//  musicity
//
//  Created by Brian Friess on 03/03/2022.
//

import Foundation
import UIKit

struct ImagePicker {
    //we create this function  for create an ImagePickerController and display the photoLibrary
    func displayPhotoLibrary(_ ViewController : UIViewController) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = (ViewController as! UIImagePickerControllerDelegate & UINavigationControllerDelegate)
        //we choose as source the photo library
        imagePicker.sourceType = .photoLibrary
        //we open the photo Library
        imagePicker.allowsEditing = true
        ViewController.present(imagePicker, animated: true, completion: nil)
    }
    
}
