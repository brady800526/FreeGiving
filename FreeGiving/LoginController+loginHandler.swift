//
//  LoginViewController+handler.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/7/28.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

import Firebase

extension LoginController {

    // Control the loginButton based on the segmentedControl value

    func handleLoginRegisterChange() {

        let title = loginSegmentedControl.titleForSegment(at: loginSegmentedControl.selectedSegmentIndex)

        loginSubmitButton.setTitle(title, for: .normal)

        inputsContainerViewHeightAnchor?.constant = loginSegmentedControl.selectedSegmentIndex == 0 ? 80 : 120
        
        nameContainerViewHeightAnchor?.constant = loginSegmentedControl.selectedSegmentIndex == 0 ? 0 : 40

    }

    // Sign in with email and password

    func handleLogin() {

        guard
            let email = loginEmailTextField.text,

            let password = loginPasswordTextField.text

            else {

                print("Form is not valid")

                return

        }

        Auth.auth().signIn(withEmail: email, password: password) { (_, error) in

            if error != nil {

                print(error!)

                return

            }
            
//            self.mapViewController?.fetchUserAndSetupNavBarTitle()
            
            self.dismiss(animated: true, completion: nil)

        }

    }

    func handleRegister() {

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

                print(error!)

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

            usersRefernece.updateChildValues(values, withCompletionBlock: { (err, _) in

                if err != nil {

                    print(err!)

                    return
                }

                print("Saved user successfully into Firebase db")
                
//                self.mapViewController?.fetchUserAndSetupNavBarTitle()

                self.mapViewController?.navigationItem.title = values["name"]
                
                self.dismiss(animated: true, completion: nil)

            })

        })

    }

}
