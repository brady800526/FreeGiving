//
//  test2ViewController.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/7/27.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

import UIKit

class ImageUploadViewController: UIViewController {
    @IBOutlet weak var uploadImageView: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var productOnShelfTime: UITextField!
    @IBOutlet weak var productLocation: UITextField!
    @IBOutlet weak var productDescription: UITextField!

    override func viewDidLoad() {

        super.viewDidLoad()
        // User can tap the imageView to select the photo
        uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectUploadImageView)))
        // Tap the button to upload the data to firebase
        uploadButton.addTarget(self, action: #selector(handleUploadProduct), for: .touchUpInside)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        // Tap outside the screen to dismiss the keyboard
        view.addGestureRecognizer(tap)
    }

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

}
