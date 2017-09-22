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
import MapKit
import SCLAlertView

extension ImageUploadController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func handleDismiss() {

        self.navigationController?.popViewController(animated: true)

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

        self.navigationController?.popViewController(animated: true)

    }

    // Handle if picker is cancel

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

        print("image cacnel")

        self.navigationController?.popViewController(animated: true)

    }

    func handleUploadProduct() {

        handleUploadPhoto()

        self.navigationController?.popViewController(animated: true)

    }

    // Save the photo to storage and take the imageURL to handleUploadText

    func handleUploadPhoto() {

        let imageName = NSUUID().uuidString

        let storageRef = Storage.storage().reference().child("postsPhoto").child("\(imageName).jpg")

        let timestamp: NSNumber = NSNumber(value: Date().timeIntervalSinceReferenceDate)

        guard let name = uploadProductName.text,
            let description = uploadProductDescription.text,
            let latitude = self.latitude,
            let longtitude = self.longtitude,
            let uid = Auth.auth().currentUser?.uid
            else {

                SCLAlertView().showWarning("Hold On", subTitle: "Make sure you enter all the info!", closeButtonTitle:"OK")

                return
        }

        if let uploadData = UIImageJPEGRepresentation(self.uploadImageView.image!, 0.1) {

            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in

                if let error = error {

                    print(error)

                    return

                }

                if let profileImageUrl = metadata?.downloadURL()?.absoluteString {

                    let values: [String: Any] =
                        ["user": uid,
                         "title": name,
                         "latitude": latitude,
                         "longitude": longtitude,
                         "productDescription": description,
                         "productImageURL": profileImageUrl,
                         "timeStamp": timestamp,
                         "available": "true"]

                    self.handleUploadText(values: values)

                }

            })

        }
    }

    // Take the URL with curr ent info to save in the database

    func handleUploadText(values: [String: Any]) {

        let ref = Database.database().reference()

        let usersRefernece = ref.child("posts").childByAutoId()

        usersRefernece.updateChildValues(values, withCompletionBlock: { (err, _) in

            if err != nil {

                print(err!)

                return
            }

            let span = MKCoordinateSpanMake(0.05, 0.05)

            guard let latitude = self.latitude,
                let longtitude = self.longtitude,
                let lat = Double(latitude),
                let lon = Double(longtitude)
                else { return }

            let region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(lat, lon), span)

            self.mapView?.setRegion(region, animated: true)

            self.navigationController?.popViewController(animated: true) // dismiss after select place

            print("Saved product detail successfully into Firebase db")

        })

    }

}
