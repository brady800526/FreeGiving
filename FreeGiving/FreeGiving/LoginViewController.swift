//
//  LoginViewController.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/7/26.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loginNameTextField: UITextField!
    @IBOutlet weak var loginEmailTextField: UITextField!
    @IBOutlet weak var loginPasswordTextField: UITextField!
    @IBOutlet weak var loginSubmitButton: UIButton!
    @IBOutlet weak var loginSegmentedControl: UISegmentedControl!
    @IBOutlet weak var loginView: UIView!

//    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
//    var nameTextFieldHeightAnchor: NSLayoutConstraint?

    // Set the style of status bar

    override var preferredStatusBarStyle: UIStatusBarStyle {

        return .lightContent

    }

    override func viewDidLoad() {

        super.viewDidLoad()

        // FIXME: Placeholder for the backgorund

        view.backgroundColor = UIColor.cyan

        // Default the selectedSegmented to SignIn and handle the value change

        loginSegmentedControl.selectedSegmentIndex = 0

        loginSegmentedControl.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)

        // Disable keyboard when tap outside the view

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))

        view.addGestureRecognizer(tap)

    }

    // Causes the view (or one of its embedded text fields) to resign the first responder status.

    func dismissKeyboard() {

        view.endEditing(true)

    }

    // Disable keyboard when return

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()

        return true
    }

    //Enter the app depends on your status

    @IBAction func register(_ sender: Any) {

        if loginSegmentedControl.selectedSegmentIndex == 0 {

            handleLogin()

        } else {

            handleRegister()

        }

    }}
