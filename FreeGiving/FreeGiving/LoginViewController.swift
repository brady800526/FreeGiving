//
//  LoginViewController.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/7/26.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var loginNameTextField: UITextField!
    @IBOutlet weak var loginEmailTextField: UITextField!
    @IBOutlet weak var loginPasswordTextField: UITextField!
    @IBOutlet weak var loginSubmitButton: UIButton!
    @IBOutlet weak var loginSegmentedControl: UISegmentedControl!
    @IBOutlet weak var loginView: UIView!
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.cyan
        
        loginSegmentedControl.selectedSegmentIndex = 0
        
        loginSegmentedControl.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        
    }
    
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func register(_ sender: Any) {
            
        guard
            let name = loginNameTextField.text,
            let email = loginEmailTextField.text,
            let password = loginPasswordTextField.text
            else {
                print("Form is not valid")
                return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            guard
                let uid = user?.uid
                else {
                    return
            }
            
            let ref = Database.database().reference()
            
            let usersRefernece = ref.child("users").child(uid)
            
            let values = ["name": name, "email": email]
            
            usersRefernece.updateChildValues(values, withCompletionBlock: { (err, ref) in
                
                if err != nil {
                    print(err)
                    return
                }
                
                print("Saved user successfully into Firebase db")
                
                self.dismiss(animated: true, completion: nil)
                
            })
            
        })
        
    }
    
    func handleLoginRegisterChange() {
        let title = loginSegmentedControl.titleForSegment(at: loginSegmentedControl.selectedSegmentIndex)
        loginSubmitButton.setTitle(title, for: .normal)
        loginView.widthAnchor.constraint(equalToConstant: loginView.frame.width * 2/3).isActive = true
        loginView.heightAnchor.constraint(equalToConstant: loginView.frame.height * 2.5/3).isActive = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
