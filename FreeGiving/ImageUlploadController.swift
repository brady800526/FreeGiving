//
//  ImageController.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/8/24.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

import UIKit
import MapKit
import GooglePlaces

class ImageUploadController: UIViewController, GMSAutocompleteViewControllerDelegate, UITextViewDelegate {

    var latitude: String?
    var longtitude: String?
    var mapView: MKMapView?

    let uploadBackgroundScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.bounces = false
        return sv
    }()

    let uploadBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 174, green: 209, blue: 233)
        return view
    }()

    lazy var uploadImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.image = #imageLiteral(resourceName: "album-placeholder")
        iv.layer.cornerRadius = 40
        iv.layer.borderWidth = 5
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.shadowOffset = CGSize(width: 3, height: 3)
        iv.layer.shadowColor = UIColor.black.cgColor
        iv.layer.shadowRadius = 5
        iv.layer.shadowOpacity = 0.5
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectUploadImageView)))
        return iv
    }()

    let uplaodDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Marker Felt", size: 32)
        label.text = "Product Description"
        label.textAlignment = .center
        label.textColor = UIColor.orange
        label.layer.shadowOffset = CGSize(width: 3, height: 3)
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 5
        label.layer.shadowOpacity = 0.3
        label.layer.cornerRadius = 20
        return label
    }()

    let uploadInputsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        return view
    }()

    let uploadProductName: UITextView = {
        let tv = UITextView()
        tv.text = "Product Name"
        tv.textColor = UIColor.lightGray
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.textAlignment = .left
        tv.font = UIFont(name: "Marker Felt", size: 20)
        tv.isScrollEnabled = false
        tv.layer.shadowOffset = CGSize(width: 3, height: 3)
        tv.layer.shadowColor = UIColor.black.cgColor
        tv.layer.shadowRadius = 5
        tv.layer.shadowOpacity = 1
        return tv
    }()

    let uploadNameSeperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 220, green: 220, blue: 220)
        return view
    }()

    let uploadProductLocation: UITextView = {
        let tv = UITextView()
        tv.text = "Product Location"
        tv.textColor = UIColor.lightGray
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.textAlignment = .left
        tv.font = UIFont(name: "Marker Felt", size: 20)
        tv.isScrollEnabled = false
        tv.layer.shadowOffset = CGSize(width: 3, height: 3)
        tv.layer.shadowColor = UIColor.black.cgColor
        tv.layer.shadowRadius = 5
        tv.layer.shadowOpacity = 1
        return tv
    }()

    let uploadLocationSeperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 220, green: 220, blue: 220)
        return view
    }()

    let uploadProductDescription: UITextView = {
        let tv = UITextView()
        tv.text = "Product Description"
        tv.textColor = UIColor.lightGray
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.textAlignment = .left
        tv.font = UIFont(name: "Marker Felt", size: 20)
        tv.isScrollEnabled = false
        tv.layer.shadowOffset = CGSize(width: 3, height: 3)
        tv.layer.shadowColor = UIColor.black.cgColor
        tv.layer.shadowRadius = 5
        tv.layer.shadowOpacity = 1
        return tv
    }()

    let uploadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.orange
        button.layer.shadowOffset = CGSize(width: 3, height: 3)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 1
        button.layer.cornerRadius = 20
        button.clipsToBounds = false
        button.setTitle("Upload", for: .normal)
        button.titleLabel?.textColor = UIColor.white
        button.titleLabel?.font = UIFont(name: "Marker Felt", size: 24)
        button.addTarget(self, action: #selector(handleUploadPhoto), for: .touchUpInside)
        return button
    }()

    let uploadProductNameDotLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "∙"
        label.textAlignment = .center
        label.textColor = UIColor.orange
        return label
    }()

    let uploadProductLocationDotLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "∙"
        label.textAlignment = .center
        label.textColor = UIColor.orange
        return label
    }()

    let uploadProductDescriptionDotLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "∙"
        label.textAlignment = .center
        label.textColor = UIColor.orange
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = UIColor.white

        self.navigationController?.navigationBar.barTintColor = UIColor.orange

        self.navigationItem.title = "Product Upload"

        uploadProductName.delegate = self
        
        uploadProductDescription.delegate = self
        
        uploadProductLocation.delegate = self

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(handleDismiss))

        self.view.addSubview(uploadBackgroundScrollView)

        setupUploadBackgroundScrollView()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))

        view.addGestureRecognizer(tap)
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

    func textViewDidBeginEditing(_ textView: UITextView) {

        if textView.textColor == UIColor.lightGray {

            textView.text = nil

            textView.textColor = UIColor.black
        }

        if textView == uploadProductLocation {

            openSearchAddress()

        }
    }
    
    func openSearchAddress() {
        
        let autoCompleteController = GMSAutocompleteViewController()
        
        autoCompleteController.delegate = self
        
        self.present(autoCompleteController, animated: true, completion: nil)
    }

    func textViewDidEndEditing(_ textView: UITextView) {

        switch textView {

        case uploadProductName:

            if uploadProductName.text.isEmpty {
                
                uploadProductName.text = "Description"
                
                uploadProductName.textColor = UIColor.lightGray
            }

        case uploadProductLocation:

            if uploadProductLocation.text.isEmpty {

                uploadProductLocation.text = "Product Name"
                
                uploadProductLocation.textColor = UIColor.lightGray
            }

        case uploadProductDescription:

            if uploadProductDescription.text.isEmpty {

                uploadProductDescription.text = "Product Location"
                
                uploadProductDescription.textColor = UIColor.lightGray

            }

        default: break

        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if textView == uploadProductName {
            
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
            
            let numberOfChars = newText.characters.count // for Swift use count(newText)
            
            return numberOfChars < 20
            
        } else if textView == uploadProductDescription {
            
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
            
            let numberOfChars = newText.characters.count // for Swift use count(newText)
            
            return numberOfChars < 100
            
        } else {
            
            return true
            
        }
    }

    func setupUploadBackgroundScrollView() {
        
        uploadBackgroundScrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        uploadBackgroundScrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        uploadBackgroundScrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        uploadBackgroundScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

        self.uploadBackgroundScrollView.addSubview(uploadBackgroundView)

        setupUploadBackgroundView()
    }

    func setupUploadBackgroundView() {
        uploadBackgroundView.topAnchor.constraint(equalTo: self.uploadBackgroundScrollView.topAnchor).isActive = true
        uploadBackgroundView.bottomAnchor.constraint(equalTo: self.uploadBackgroundScrollView.bottomAnchor, constant: 12).isActive = true
        uploadBackgroundView.leftAnchor.constraint(equalTo: self.uploadBackgroundScrollView.leftAnchor).isActive = true
        uploadBackgroundView.rightAnchor.constraint(equalTo: self.uploadBackgroundScrollView.rightAnchor).isActive = true
        uploadBackgroundView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true

        self.uploadBackgroundView.addSubview(uploadImageView)
        self.uploadBackgroundView.addSubview(uplaodDescriptionLabel)
        self.uploadBackgroundView.addSubview(uploadInputsContainerView)
        self.uploadBackgroundView.addSubview(uploadButton)

        setupUploadImageView()
        setupUploadDescriptionLabel()
        setupUploadInputsConstraintView()
        setupUploadButton()
    }

    func setupUploadImageView() {
        uploadImageView.topAnchor.constraint(equalTo: self.uploadBackgroundView.topAnchor, constant: 20).isActive = true
        uploadImageView.leftAnchor.constraint(equalTo: self.uploadBackgroundView.leftAnchor, constant: 40).isActive = true
        uploadImageView.rightAnchor.constraint(equalTo: self.uploadBackgroundView.rightAnchor, constant: -40).isActive = true
        uploadImageView.heightAnchor.constraint(equalTo: self.uploadImageView.widthAnchor, multiplier: 1).isActive = true
    }

    func setupUploadDescriptionLabel() {
        uplaodDescriptionLabel.topAnchor.constraint(equalTo: self.uploadImageView.bottomAnchor, constant: 8).isActive = true
        uplaodDescriptionLabel.centerXAnchor.constraint(equalTo: self.uploadImageView.centerXAnchor).isActive = true
        uplaodDescriptionLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9).isActive = true
        uplaodDescriptionLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    func setupUploadInputsConstraintView() {
        uploadInputsContainerView.topAnchor.constraint(equalTo: self.uplaodDescriptionLabel.bottomAnchor, constant: 8).isActive = true
        uploadInputsContainerView.bottomAnchor.constraint(equalTo: self.uploadButton.topAnchor, constant: -24).isActive = true
        uploadInputsContainerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        uploadInputsContainerView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9).isActive = true

        uploadInputsContainerView.addSubview(uploadProductNameDotLabel)
        uploadInputsContainerView.addSubview(uploadProductLocationDotLabel)
        uploadInputsContainerView.addSubview(uploadProductDescriptionDotLabel)

        uploadInputsContainerView.addSubview(uploadProductName)
        uploadInputsContainerView.addSubview(uploadProductLocation)
        uploadInputsContainerView.addSubview(uploadProductDescription)
        uploadInputsContainerView.addSubview(uploadNameSeperatorView)
        uploadInputsContainerView.addSubview(uploadLocationSeperatorView)

        setupUploadProductNameDotLabel()
        setupUploadProductName()
        setupUploadProductLocationDotLabel()
        setupUploadProductLocation()
        setupUploadProductDescriptionDotLabel()
        setupUploadProductDescription()

        setupUploadNameSeperatorView()
        setupUploadLocationSeperatorView()

    }

    func setupUploadProductName() {
        uploadProductName.topAnchor.constraint(equalTo: uploadInputsContainerView.topAnchor).isActive = true
        uploadProductName.leftAnchor.constraint(equalTo: uploadProductNameDotLabel.rightAnchor).isActive = true
        uploadProductName.rightAnchor.constraint(equalTo: uploadInputsContainerView.rightAnchor).isActive = true
        uploadProductName.bottomAnchor.constraint(equalTo: uploadProductLocation.topAnchor).isActive = true
    }

    func setupUploadProductNameDotLabel() {
        uploadProductNameDotLabel.leftAnchor.constraint(equalTo: self.uploadInputsContainerView.leftAnchor).isActive = true
        uploadProductNameDotLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        uploadProductNameDotLabel.topAnchor.constraint(equalTo: self.uploadProductName.topAnchor).isActive = true
        uploadProductNameDotLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true

    }

    func setupUploadNameSeperatorView() {
        uploadNameSeperatorView.topAnchor.constraint(equalTo: uploadProductName.bottomAnchor).isActive = true
        uploadNameSeperatorView.leftAnchor.constraint(equalTo: uploadInputsContainerView.leftAnchor).isActive = true
        uploadNameSeperatorView.rightAnchor.constraint(equalTo: uploadInputsContainerView.rightAnchor).isActive = true
        uploadNameSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }

    func setupUploadProductLocation() {
        uploadProductLocation.topAnchor.constraint(equalTo: uploadProductName.bottomAnchor).isActive = true
        uploadProductLocation.leftAnchor.constraint(equalTo: uploadProductLocationDotLabel.rightAnchor).isActive = true
        uploadProductLocation.rightAnchor.constraint(equalTo: uploadInputsContainerView.rightAnchor).isActive = true
        uploadProductLocation.bottomAnchor.constraint(equalTo: uploadProductDescription.topAnchor).isActive = true
    }

    func setupUploadProductLocationDotLabel() {
        uploadProductLocationDotLabel.leftAnchor.constraint(equalTo: self.uploadInputsContainerView.leftAnchor).isActive = true
        uploadProductLocationDotLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        uploadProductLocationDotLabel.topAnchor.constraint(equalTo: self.uploadProductName.bottomAnchor).isActive = true
        uploadProductLocationDotLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }

    func setupUploadLocationSeperatorView() {
        uploadLocationSeperatorView.topAnchor.constraint(equalTo: uploadProductLocation.bottomAnchor).isActive = true
        uploadLocationSeperatorView.leftAnchor.constraint(equalTo: uploadInputsContainerView.leftAnchor).isActive = true
        uploadLocationSeperatorView.rightAnchor.constraint(equalTo: uploadInputsContainerView.rightAnchor).isActive = true
        uploadLocationSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true

    }

    func setupUploadProductDescription() {
        uploadProductDescription.topAnchor.constraint(equalTo: uploadProductLocation.bottomAnchor).isActive = true
        uploadProductDescription.leftAnchor.constraint(equalTo: uploadProductDescriptionDotLabel.rightAnchor).isActive = true
        uploadProductDescription.rightAnchor.constraint(equalTo: uploadInputsContainerView.rightAnchor).isActive = true
        uploadProductDescription.bottomAnchor.constraint(equalTo: uploadInputsContainerView.bottomAnchor).isActive = true
    }

    func setupUploadProductDescriptionDotLabel() {
        uploadProductDescriptionDotLabel.leftAnchor.constraint(equalTo: self.uploadInputsContainerView.leftAnchor).isActive = true
        uploadProductDescriptionDotLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        uploadProductDescriptionDotLabel.topAnchor.constraint(equalTo: self.uploadProductLocation.bottomAnchor).isActive = true
        uploadProductDescriptionDotLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }

    func setupUploadButton() {
        uploadButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        uploadButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        uploadButton.widthAnchor.constraint(equalTo: self.uploadInputsContainerView.widthAnchor).isActive = true
        uploadButton.bottomAnchor.constraint(equalTo: self.uploadBackgroundView.bottomAnchor, constant: -50).isActive = true
    }

}
