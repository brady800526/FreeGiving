////
////  LoginViewController.swift
////  FreeGiving
////
////  Created by Brady Huang on 2017/7/26.
////  Copyright © 2017年 AppWorks. All rights reserved.
////
//
//import UIKit
//import Firebase
//import SDWebImage
//
//class LoginController: UIViewController, UITextFieldDelegate {
//
//    @IBOutlet weak var loginNameTextField: UITextField!
//    @IBOutlet weak var loginEmailTextField: UITextField!
//    @IBOutlet weak var loginPasswordTextField: UITextField!
//    @IBOutlet weak var loginSubmitButton: UIButton!
//    @IBOutlet weak var loginSegmentedControl: UISegmentedControl!
//    @IBOutlet weak var loginView: UIView!
//    @IBOutlet weak var loginImageView: UIImageView!
//
//    var mapViewController: MapController?
//    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
//    var nameContainerViewHeightAnchor: NSLayoutConstraint?
//    var emailContainerViewHeightAnchor: NSLayoutConstraint?
//    var passwordContainerViewHeightAnchor: NSLayoutConstraint?
//
//    override func viewDidLoad() {
//
//        super.viewDidLoad()
//
//        backgroundImageSetup()
//
//        inputViewSetup()
//
//        // Default the selectedSegmented to SignIn and handle the value change
//
//        loginSegmentedControl.selectedSegmentIndex = 0
//
//        loginSegmentedControl.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
//
//        // Disable keyboard when tap outside the view
//
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//
//        view.addGestureRecognizer(tap)
//
//    }
//
//    func backgroundImageSetup() {
//        
//        self.view.backgroundColor = UIColor.black
//
//        loginImageView.image = UIImage(named: "loginImage")
//
//        loginImageView.backgroundColor = UIColor.black
//        
//        loginImageView.alpha = 0.7
//
//    }
//
//    func inputViewSetup() {
//
//        inputsContainerViewHeightAnchor = loginView.heightAnchor.constraint(equalToConstant: 80)
//
//        inputsContainerViewHeightAnchor?.isActive = true
//
//        nameContainerViewHeightAnchor = loginNameTextField.heightAnchor.constraint(equalToConstant: 0)
//        nameContainerViewHeightAnchor?.isActive = true
//
//        emailContainerViewHeightAnchor = loginNameTextField.heightAnchor.constraint(equalToConstant: 40)
//        emailContainerViewHeightAnchor?.isActive = true
//
//        passwordContainerViewHeightAnchor = loginNameTextField.heightAnchor.constraint(equalToConstant: 40)
//        passwordContainerViewHeightAnchor?.isActive = true
//
//    }
//
//    // Causes the view (or one of its embedded text fields) to resign the first responder status.
//
//    func dismissKeyboard() {
//
//        view.endEditing(true)
//
//    }
//
//    // Disable keyboard when return
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//
//        textField.resignFirstResponder()
//
//        return true
//    }
//
//    //Enter the app depends on your status
//
//    @IBAction func register(_ sender: Any) {
//
//        if loginSegmentedControl.selectedSegmentIndex == 0 {
//
//            handleLogin()
//
//        } else {
//
//            handleRegister()
//
//        }
//
//    }
//}
//
//
