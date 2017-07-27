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

        uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectUploadImageView)))
        
        uploadButton.addTarget(self, action: #selector(handleUploadProduct), for: .touchUpInside)
    }

}
