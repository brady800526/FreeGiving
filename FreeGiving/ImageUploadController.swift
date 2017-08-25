//
//  test2ViewController.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/7/27.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

import UIKit
import MapKit
import GooglePlaces

class ImageUploadController: UIViewController, GMSAutocompleteViewControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var uploadImageView: UIImageView!
    @IBOutlet weak var uploadProductName: UITextView!
    @IBOutlet weak var uploadProductLocation: UITextView!
    @IBOutlet weak var uploadProductDescription: UITextView!
    @IBOutlet weak var uploadButton: UIButton!

    // Tap the button to upload the data to firebase

    @IBAction func upload(_ sender: Any) {
        handleUploadPhoto()
    }

    var latitude: String?
    var longtitude: String?
    var mapView: MKMapView?
    let textViewPlaceHolder = ["Product Name", "Product Location", "Product Description"]

    override func viewDidLoad() {

        self.navigationController?.navigationBar.tintColor = UIColor.white

        self.navigationController?.navigationBar.barTintColor = UIColor.orange

        self.navigationItem.title = "Product"

        super.viewDidLoad()

        let textViews: [UITextView] = [uploadProductName, uploadProductLocation, uploadProductDescription]

        for index in 0 ..< textViews.count {

            textViews[index].text = textViewPlaceHolder[index]

            textViews[index].textColor = UIColor.lightGray

        }

        uploadButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        uploadButton.layer.shadowColor = UIColor.black.cgColor
        uploadButton.layer.shadowRadius = 5
        uploadButton.layer.shadowOpacity = 1
        uploadButton.clipsToBounds = false

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(handleDismiss))

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

        self.uploadProductLocation.text = place.formattedAddress

        self.uploadProductLocation.textColor = UIColor.black

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

        if textView == uploadProductLocation {

            openSearchAddress()

        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {

        switch textView {

        case uploadProductName:

            if uploadProductName.text.isEmpty {
                uploadProductName.text = textViewPlaceHolder[0]
                uploadProductName.textColor = UIColor.lightGray
            }

        case uploadProductLocation:

            if uploadProductLocation.text.isEmpty {

                uploadProductLocation.text = textViewPlaceHolder[1]
                uploadProductLocation.textColor = UIColor.lightGray
            }

        case uploadProductDescription:

            if uploadProductDescription.text.isEmpty {

                uploadProductDescription.text = textViewPlaceHolder[2]
                uploadProductDescription.textColor = UIColor.lightGray

            }

        default: break

        }
    }
}
