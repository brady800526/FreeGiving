//
//  test2ViewController.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/7/27.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

import UIKit
import GooglePlaces

class ImageUploadController: UIViewController, GMSAutocompleteViewControllerDelegate, UITextViewDelegate {
    
    @IBOutlet weak var uploadImageView: UIImageView!
    @IBOutlet weak var productName: UITextView!
    @IBOutlet weak var productLocation: UITextView!
    @IBOutlet weak var productDescription: UITextView!
    @IBOutlet weak var uploadButton: UIButton!
    
    // Tap the button to upload the data to firebase

    @IBAction func upload(_ sender: Any) {
        handleUploadPhoto()
    }

    var latitude: String?
    var longtitude: String?
    let textViewPlaceHolder = ["Product Name", "Product Location", "Product Description"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let textViews: [UITextView] = [productName, productLocation, productDescription]
        
        for index in 0 ..< textViews.count {
            
            textViews[index].text = textViewPlaceHolder[index]

            textViews[index].textColor = UIColor.lightGray
            
        }
        
        uploadButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        uploadButton.layer.shadowColor = UIColor.black.cgColor
        uploadButton.layer.shadowRadius = 5
        uploadButton.layer.shadowOpacity = 1
        uploadButton.clipsToBounds = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(handleDismiss))
        
        // User can tap the imageView to select the photo
        uploadImageView.isUserInteractionEnabled = true
        
        uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectUploadImageView)))
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        //         Tap outside the screen to dismiss the keyboard
        view.addGestureRecognizer(tap)
        
        //        setLocationSearchTable()
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        print(place)
        
        self.productLocation.text = place.formattedAddress
        
        self.productLocation.textColor = UIColor.black

        self.latitude = String(place.coordinate.latitude)

        self.longtitude = String(place.coordinate.longitude)
        
        self.dismiss(animated: true, completion: nil) // dismiss after select place
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        
        print("ERROR AUTO COMPLETE \(error)")
        
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil) // when cancel search
    }
    
    func openSearchAddress() {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray {

            textView.text = nil

            textView.textColor = UIColor.black
        }
        
        if textView == productLocation {
            
            openSearchAddress()
            
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        switch textView {
            
        case productName:
            
            if productName.text.isEmpty {
                productName.text = textViewPlaceHolder[0]
                productName.textColor = UIColor.lightGray
            }
            
        case productLocation:
            
            if productLocation.text.isEmpty {
                
                productLocation.text = textViewPlaceHolder[1]
                productLocation.textColor = UIColor.lightGray
            }
            
        case productDescription:
            
            if productDescription.text.isEmpty {
                
                productDescription.text = textViewPlaceHolder[2]
                productDescription.textColor = UIColor.lightGray
                
            }
         
        default: break
            
        }
    }
}
