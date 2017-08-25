//
//  ImageController.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/8/24.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

import UIKit

class ImageController: UIViewController {

    let uploadBackgroundScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    let uploadBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray
        return view
    }()

    lazy var uploadImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.image = UIImage(named: "album-placeholder")
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectUploadImageView)))
        return iv
    }()
    
    let uplaodDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Marker Felt", size: 24)
        label.text = "Description"
        label.textAlignment = .center
        label.textColor = UIColor.orange
        return label
    }()
    
    let uploadInputsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let uploadProductName: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let uploadProductLocation: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let uploadProductDescription: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
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
        button.clipsToBounds = false
        button.titleLabel?.text = "Upload Prooduct"
        button.titleLabel?.textColor = UIColor.orange
        button.titleLabel?.font = UIFont(name: "Marker Felt", size: 24)
        return button
    }()


    func handleSelectUploadImageView() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
 
        self.uploadBackgroundScrollView.alwaysBounceVertical = true
        
        

        self.view.addSubview(uploadBackgroundScrollView)

        setupUploadBackgroundScrollView()
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
        uploadBackgroundView.leftAnchor.constraint(equalTo: self.uploadBackgroundScrollView.leftAnchor).isActive = true
        uploadBackgroundView.rightAnchor.constraint(equalTo: self.uploadBackgroundScrollView.rightAnchor).isActive = true
        uploadBackgroundView.bottomAnchor.constraint(equalTo: self.uploadBackgroundScrollView.bottomAnchor, constant: 12).isActive = true
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
        uploadImageView.topAnchor.constraint(equalTo: self.uploadBackgroundView.topAnchor).isActive = true
        uploadImageView.leftAnchor.constraint(equalTo: self.uploadBackgroundView.leftAnchor).isActive = true
        uploadImageView.widthAnchor.constraint(equalTo: self.uploadBackgroundView.widthAnchor).isActive = true
        uploadImageView.heightAnchor.constraint(equalTo: self.uploadImageView.widthAnchor, multiplier: 1).isActive = true
    }

    func setupUploadDescriptionLabel() {
        uplaodDescriptionLabel.topAnchor.constraint(equalTo: self.uploadImageView.bottomAnchor).isActive = true
        uplaodDescriptionLabel.centerXAnchor.constraint(equalTo: self.uploadImageView.centerXAnchor).isActive = true
        uplaodDescriptionLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9).isActive = true
        uplaodDescriptionLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupUploadInputsConstraintView() {
        uploadInputsContainerView.topAnchor.constraint(equalTo: self.uplaodDescriptionLabel.bottomAnchor).isActive = true
        uploadInputsContainerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        uploadInputsContainerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        uploadInputsContainerView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9).isActive = true
    }
    
    func setupUploadButton() {
        uploadButton.topAnchor.constraint(equalTo: self.uploadInputsContainerView.bottomAnchor, constant: 12).isActive = true
        uploadButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        uploadButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        uploadButton.widthAnchor.constraint(equalTo: self.uploadInputsContainerView.widthAnchor).isActive = true
        uploadButton.bottomAnchor.constraint(equalTo: self.uploadBackgroundView.bottomAnchor, constant: -12).isActive = true
    }

}
