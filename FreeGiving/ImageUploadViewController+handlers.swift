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
import CoreLocation

extension ImageUploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func handleDismiss() {

        self.dismiss(animated: true, completion: nil)

    }

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
    
    // Take the URL with current info to save in the database
    
    func handleUploadText(ImageUrl: String) {
        
        let ref = Database.database().reference()
        
        let usersRefernece = ref.child("posts").childByAutoId()
        
        let date : Date = Date()

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy MM dd,hh mm"

        dateFormatter.string(from: date)
        
        guard let name = productName.text,
            let time = productOnShelfTime.text,
            let location = productOnShelfTime.text,
            let description = productDescription.text,
            let latitude = self.latitude,
            let longtitude = self.longtitude,
            let uid = Auth.auth().currentUser?.uid
            else {
                
                print("format error")
                
                return
        }
        
        let values: [String: Any] =
            ["user": uid,
             "productName": name,
             "productOnShelfTime": time,
             "latitude": latitude,
             "longtitude": longtitude,
             "productDescription": description,
             "productImageURL": ImageUrl,
             "timeStamp": dateFormatter.string(from: date),
             "available": true]
        
        usersRefernece.updateChildValues(values, withCompletionBlock: { (err, _) in
            
            if err != nil {
                
                print(err!)
                
                return
            }
            
            print("Saved product detail successfully into Firebase db")
            
        })
        
    }

}

extension ImageUploadViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        let geoCoder = CLGeocoder()

        switch textField {

        case productLocation:

            guard let address = productLocation.text else { return true }

            geoCoder.geocodeAddressString(address, completionHandler: { (placemarks, error) in
                if let error = error {
                    
                    print(error)
                    
                    return
                }
                
                guard let placemark = placemarks?.first,
                    let lat = placemark.location?.coordinate.latitude,
                    let lon = placemark.location?.coordinate.longitude
                    else {
                        return }
                    print("Lat: \(lat), Lon: \(lon)")
                self.latitude = lat
                self.longtitude = lon
                
            })

        return true

        default: print("nothing return")

        return true

        }

    }

}
