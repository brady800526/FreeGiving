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

    var latitude: String?
    var longtitude: String?
    
    
    override func viewDidLoad() {
        
        productName.text = "Product Name"
        productName.textColor = UIColor.lightGray
        
        productLocation.text = "Product Location"
        productLocation.textColor = UIColor.lightGray
        
        productDescription.text = "Product Description"
        productDescription.textColor = UIColor.lightGray
        
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "cancel", style: .plain, target: self, action: #selector(handleDismiss))
        
        // Tap the button to upload the data to firebase
        //        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "upload", style: .plain, target: self, action: #selector(handleUploadProduct))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "upload", style: .plain, target: self, action: #selector(openSearchAddress))
        
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
        
        self.dismiss(animated: true, completion: nil) // dismiss after select place
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        
        print("ERROR AUTO COMPLETE \(error)")
        
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil) // when cancel search
    }
    
    func openSearchAddress(_ sender: UIBarButtonItem) {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        print(123)
        
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        print(123)
        
        switch textView {
            
        case productName:
            
            if productName.text.isEmpty {
                productName.text = "Placeholder"
                productName.textColor = UIColor.lightGray
            }
            
        case productLocation:
            
            if productLocation.text.isEmpty {
                
                productLocation.text = "Placeholder"
                productLocation.textColor = UIColor.lightGray
            }
            
        case productDescription:
            
            if productDescription.text.isEmpty {
                
                productDescription.text = "Placeholder"
                productDescription.textColor = UIColor.lightGray
                
            }
         
        default: break
            
        }
    }
}
