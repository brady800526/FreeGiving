//
//  LoginController+handlers.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/7/27.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension ImageUploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Handle imageview when selected
    
    func handleSelectUploadImageView() {

        let picker = UIImagePickerController()
        
        picker.delegate = self
        
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    // Optional crop the image if user wanted
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            
            selectedImageFromPicker = editedImage

        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
            
        }
        
        if let selectedImage = selectedImageFromPicker {
            
            uploadImageView.image = selectedImage
            
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    // Handle if picker is cancel
 
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        print("image cacnel")

        dismiss(animated: true, completion: nil)
        
    }
    
    func handleUploadProduct() {

        handleUploadPhoto()

        self.dismiss(animated: true, completion: nil)

    }
    
    // Take the URL with current info to save in the database
    
    func handleUploadText(ImageUrl: String) {
        
        let ref = Database.database().reference()
        
        let usersRefernece = ref.child("posts").childByAutoId()
        
        guard let name = productName.text,
            let time = productOnShelfTime.text,
            let location = productOnShelfTime.text,
            let description = productDescription.text,
            let uid = Auth.auth().currentUser?.uid
            else {
                
                print("format error")
                
                return
        }
        
        let values: [String:Any] =
            ["user": uid,
             "productName": name,
             "productOnShelfTime": time,
             "productLocation": location,
             "productDescription": description,
             "productImageURL": ImageUrl]
        
        usersRefernece.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                
                print(err!)
                
                return
            }
            
            print("Saved product detail successfully into Firebase db")
            
        })
        
    }

    // Save the photo to storage and take the imageURL to handleUploadText
    
    func handleUploadPhoto() {
        
        let imageName = NSUUID().uuidString
        
        let storageRef = Storage.storage().reference().child("postsPhoto").child("\(imageName).png")

        if let uploadData = UIImagePNGRepresentation(self.uploadImageView.image!) {
            
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if let error = error {
                    
                    print(error)
                    
                    return
                }
                
                if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                    
                    print(profileImageUrl)
                    
                    self.handleUploadText(ImageUrl: profileImageUrl)
                    
                }
                
            })
            
        }
    }
}
