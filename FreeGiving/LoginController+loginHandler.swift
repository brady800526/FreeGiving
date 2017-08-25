//
//  LoginViewController+handler.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/7/28.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

import Firebase
import SCLAlertView

extension LoginController {

    // Sign in with email and password

    func handleLogin() {

        guard
            let email = emailTextField.text,

            let password = passwordTextField.text

            else {

                print("Form is not valid")

                return

        }

        Auth.auth().signIn(withEmail: email, password: password) { (_, error) in

            if let error = error {

                SCLAlertView().showWarning("Hold On", subTitle:error.localizedDescription, closeButtonTitle:"OK")

                return

            }

            self.mapViewController?.fetchUserAndSetupNavBarTitle()

            self.dismiss(animated: true, completion: nil)

        }

    }

    func handleRegister() {

        guard

            let name = nameTextField.text,

            let email = emailTextField.text,

            let password = passwordTextField.text

            else {

                print("Form is not valid")

                return

        }

        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in

            if let error = error {

                SCLAlertView().showWarning("Hold On", subTitle:error.localizedDescription, closeButtonTitle:"OK")
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

                self.mapViewController?.fetchUserAndSetupNavBarTitle()

                self.dismiss(animated: true, completion: nil)

            })

        })

    }

}
