////
////  LoginViewController.swift
////  FreeGiving
////
////  Created by Brady Huang on 2017/8/22.
////  Copyright © 2017年 AppWorks. All rights reserved.
////
//
//import UIKit
//
//class LoginViewController: UIViewController {
//
//    let inputsContainerView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor.white
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.layer.cornerRadius = 5
//        view.layer.masksToBounds = true
//        return view
//    }()
//
//    let nameTextField: UITextField = {
//        let tv = UITextField()
////        tv.backgroundColor = UIColor(red: 80, green: 101, blue: 161)
//        tv.translatesAutoresizingMaskIntoConstraints = false
//        tv.placeholder = "  Name"
//        return tv
//    }()
//
//    let emailTextField: UITextField = {
//        let tv = UITextField()
////        tv.backgroundColor = UIColor(red: 80, green: 101, blue: 161)
//        tv.translatesAutoresizingMaskIntoConstraints = false
//        tv.placeholder = "  Email address"
//        return tv
//    }()
//
//    let passwordTextField: UITextField = {
//        let tv = UITextField()
////        tv.backgroundColor = UIColor(red: 80, green: 101, blue: 161)
//        tv.translatesAutoresizingMaskIntoConstraints = false
//        tv.placeholder = "  Password"
//        return tv
//    }()
//
//    let nameSeparatorView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor(red: 220, green: 220, blue: 220)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    let emailSeparatorView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor(red: 220, green: 220, blue: 220)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    let loginRegisterSegmentedControl: UISegmentedControl = {
//        let sc = UISegmentedControl(items: ["Login", "Register"])
//        sc.translatesAutoresizingMaskIntoConstraints = false
//        sc.tintColor = UIColor.white
//        sc.selectedSegmentIndex = 0
//        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
//        return sc
//    }()
//
//    func handleLoginRegisterChange() {
//        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
//        loginRegisterButton.setTitle(title, for: .normal)
//
//        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
//
//        nameTextFieldHeightAnchor?.isActive = false
//        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
//        nameTextFieldHeightAnchor?.isActive = true
//        nameTextField.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? true : false
//        nameSeparatorView.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? true : false
//
//        emailTextFieldHeightAnchor?.isActive = false
//        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
//        emailTextFieldHeightAnchor?.isActive = true
//
//        passwordTextFieldViewHeightAnchor?.isActive = false
//        passwordTextFieldViewHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
//        passwordTextFieldViewHeightAnchor?.isActive = true
//    }
//
//    let loginRegisterButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Login", for: .normal)
//        button.backgroundColor = UIColor(red: 80, green: 101, blue: 161)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitleColor(UIColor.white, for: .normal)
//        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
//        return button
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.backgroundColor = UIColor(red: 61, green: 91, blue: 151)
//        self.view.addSubview(inputsContainerView)
//        self.view.addSubview(loginRegisterButton)
//        self.view.addSubview(loginRegisterSegmentedControl)
//
//        setupInputsContainerView()
//        setupLoginRegisterButton()
//        setupLoginRegisterSegmentedControl()
//    }
//
//    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
//    var nameTextFieldHeightAnchor: NSLayoutConstraint?
//    var emailTextFieldHeightAnchor: NSLayoutConstraint?
//    var passwordTextFieldViewHeightAnchor: NSLayoutConstraint?
//
//    func setupInputsContainerView() {
//
//        inputsContainerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        inputsContainerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
//        inputsContainerView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -36).isActive = true
//        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 100)
//        inputsContainerViewHeightAnchor?.isActive = true
//
//        self.inputsContainerView.addSubview(nameTextField)
//        self.inputsContainerView.addSubview(nameSeparatorView)
//        self.inputsContainerView.addSubview(emailTextField)
//        self.inputsContainerView.addSubview(emailSeparatorView)
//        self.inputsContainerView.addSubview(passwordTextField)
//
//        nameTextField.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
//        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
//        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
//        nameTextField.isHidden = true
//        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 0)
//            nameTextFieldHeightAnchor?.isActive = true
//
//        nameSeparatorView.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
//        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
//        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
//        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
//        nameSeparatorView.isHidden = true
//
//        emailTextField.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
//        emailTextField.topAnchor.constraint(equalTo: nameSeparatorView.bottomAnchor).isActive = true
//        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
//        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2)
//            emailTextFieldHeightAnchor?.isActive = true
//
//        emailSeparatorView.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
//        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
//        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
//        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
//
//        passwordTextField.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
//        passwordTextField.topAnchor.constraint(equalTo: emailSeparatorView.bottomAnchor).isActive = true
//        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
//        passwordTextFieldViewHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2)
//            passwordTextFieldViewHeightAnchor?.isActive = true
//    }
//
//    func setupLoginRegisterButton() {
//        loginRegisterButton.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
//        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
//        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
//        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
//    }
//
//    func setupLoginRegisterSegmentedControl() {
//        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
//        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
//        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
//        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
//    }
//}
//
//extension UIColor {
//
//    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
//        self.init(red: red/255, green: green/255, blue: blue/255, alpha: 1)
//    }
//
//}
