//
//  LoginViewController.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/8/22.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

import UIKit
import MapKit

class LoginController: UIViewController {

    var mapViewController: MapController?

    let loginBackgroundImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "loginImage")
        imageView.backgroundColor = UIColor.black
        imageView.alpha = 0.7
        return imageView
    }()

    let loginTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Free Giving"
        label.font = UIFont(name: "Marker Felt", size: 56)
        label.textColor = UIColor.titleYellow()
        label.textAlignment = .center
        return label
    }()

    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.backgroundGray()
        view.alpha = 0.6
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()

    let nameTextField: UITextField = {
        let tv = UITextField()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.placeholder = "Name"
        tv.textAlignment = .center
        tv.font = UIFont(name: "Marker Felt", size: 24)
        return tv
    }()

    let emailTextField: UITextField = {
        let tv = UITextField()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.placeholder = "Email address"
        tv.textAlignment = .center
        tv.font = UIFont(name: "Marker Felt", size: 24)
        tv.autocapitalizationType = .none
        return tv
    }()

    let passwordTextField: UITextField = {
        let tv = UITextField()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.placeholder = "Password"
        tv.textAlignment = .center
        tv.font = UIFont(name: "Marker Felt", size: 24)
        tv.autocapitalizationType = .none
        tv.isSecureTextEntry = true
        return tv
    }()

    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.separatorColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.separatorColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let EULALabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "By using the application, you agree to the Terms of Service, and privacy Policy"
        label.numberOfLines = 0
        label.font = UIFont(name: "Marker Felt", size: 16)
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()

    let loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()

    func handleLoginRegisterChange() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)

        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150

        nameTextFieldHeightAnchor?.isActive = false
        
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(
            equalTo: inputsContainerView.heightAnchor,
            multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3
        )
        
        nameTextFieldHeightAnchor?.isActive = true
        nameTextField.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? true : false
        nameSeparatorView.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? true : false

        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(
            equalTo: inputsContainerView.heightAnchor,
            multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3
        )
        
        emailTextFieldHeightAnchor?.isActive = true

        passwordTextFieldViewHeightAnchor?.isActive = false
        passwordTextFieldViewHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo:
            inputsContainerView.heightAnchor,
            multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3
        )
        
        passwordTextFieldViewHeightAnchor?.isActive = true
    }

    let loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor.clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.titleLabel?.font = UIFont(name: "Marker Felt", size: 24)
        button.addTarget(self, action: #selector(setupLoginRegister), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView?.tintColor = UIColor.white

        self.view.addSubview(loginBackgroundImageView)
        self.view.addSubview(loginTitleLabel)
        self.view.addSubview(inputsContainerView)
        self.view.addSubview(loginRegisterButton)
        self.view.addSubview(loginRegisterSegmentedControl)
        self.view.addSubview(EULALabel)

        setupLoginBackgroundImageView()
        setupInputsContainerView()
        setupLoginTitleLabel()
        setupLoginRegisterButton()
        setupLoginRegisterSegmentedControl()
        setupEULALabel()

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

    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldViewHeightAnchor: NSLayoutConstraint?

    func setupLoginBackgroundImageView() {
        loginBackgroundImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        loginBackgroundImageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        loginBackgroundImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        loginBackgroundImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }

    func setupLoginTitleLabel() {
        loginTitleLabel.centerXAnchor.constraint(equalTo: loginRegisterSegmentedControl.centerXAnchor).isActive = true
        loginTitleLabel.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor).isActive = true
        loginTitleLabel.widthAnchor.constraint(equalTo: loginRegisterSegmentedControl.widthAnchor).isActive = true
        loginTitleLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }

    func setupInputsContainerView() {

        inputsContainerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.7).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 100)
        inputsContainerViewHeightAnchor?.isActive = true

        self.inputsContainerView.addSubview(nameTextField)
        self.inputsContainerView.addSubview(nameSeparatorView)
        self.inputsContainerView.addSubview(emailTextField)
        self.inputsContainerView.addSubview(emailSeparatorView)
        self.inputsContainerView.addSubview(passwordTextField)

        nameTextField.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextField.isHidden = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 0)
            nameTextFieldHeightAnchor?.isActive = true

        nameSeparatorView.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        nameSeparatorView.isHidden = true

        emailTextField.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameSeparatorView.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2)
            emailTextFieldHeightAnchor?.isActive = true

        emailSeparatorView.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true

        passwordTextField.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailSeparatorView.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextFieldViewHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2)
            passwordTextFieldViewHeightAnchor?.isActive = true
    }

    func setupLoginRegisterButton() {
        loginRegisterButton.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: EULALabel.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    func setupLoginRegisterSegmentedControl() {
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    func setupEULALabel() {
        
        EULALabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        EULALabel.widthAnchor.constraint(equalTo: self.inputsContainerView.widthAnchor).isActive = true
        EULALabel.topAnchor.constraint(equalTo: self.inputsContainerView.bottomAnchor).isActive = true
        EULALabel.bottomAnchor.constraint(equalTo: self.loginRegisterButton.topAnchor).isActive = true
        
    }

    func setupLoginRegister() {

        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {

            handleLogin()

        } else {

            handleRegister()

        }

    }
}

extension UIColor {

    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.init(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    class func titleYellow() -> UIColor {
        return UIColor(red: 247, green: 207, blue: 54)
    }

    class func backgroundGray() -> UIColor {
        return UIColor(red: 230, green: 230, blue: 230)
    }
    
    class func separatorColor() -> UIColor {
        return UIColor(red: 220, green: 220, blue: 220)
    }
}
