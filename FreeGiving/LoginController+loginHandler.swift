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
                
                let appearance = SCLAlertView.SCLAppearance(
                    kWindowWidth: self.view.frame.width,
                    kWindowHeight: self.view.frame.height
                )
                
                let infoView = SCLAlertView(appearance: appearance)
                
                infoView.showInfo("End-User License Agreement", subTitle:
                    
                    "\nThis End-User License Agreement (\"EULA\") is a legal agreement between you and FreeGiving\n\n" +
                    
                    "This EULA agreement governs your acquisition and use of our FreeGiving software directly from Brady Huang." +
                    
                    "Please read this EULA agreement carefully before using the FreeGiving software. It provides a license to use the FreeGiving software and contains warranty information and liability disclaimers." +
                    
                    "If you register for a free trial of the FreeGiving software, this EULA agreement will also govern that trial. By clicking \"OK\" or installing and/or using the FreeGiving software, you are confirming your acceptance of the Software and agreeing to become bound by the terms of this EULA agreement." +
                    
                    "If you are entering into this EULA agreement on behalf of a company or other legal entity, you represent that you have the authority to bind such entity and its affiliates to these terms and conditions. If you do not have such authority or if you do not agree with the terms and conditions of this EULA agreement, do not install or use the Software, and you must not accept this EULA agreement." +
                    
                    "This EULA agreement shall apply only to the Software supplied by FreeGiving herewith regardless of whether other software is referred to or described herein. The terms also apply to any FreeGiving updates, supplements, Internet-based services, and support services for the Software, unless other terms accompany those items on delivery. If so, those terms apply." +
                    
                    "\n\nLicense Grant\n\n" +
                    
                    "FreeGiving hereby grants you a personal, non-transferable, non-exclusive licence to use the FreeGiving software on your devices in accordance with the terms of this EULA agreement.\n" +
                    
                    "You are permitted to load the FreeGiving software (for example a PC, laptop, mobile or tablet) under your control. You are responsible for ensuring your device meets the minimum requirements of the FreeGiving software.\n" +
                    
                    "You are not permitted to:" +
                    
                    
                    "- Edit, alter, modify, adapt, translate or otherwise change the whole or any part of the Software nor permit the whole or any part of the Software to be combined with or become incorporated in any other software, nor decompile, disassemble or reverse engineer the Software or attempt to do any such things\n" +
                    "- Reproduce, copy, distribute, resell or otherwise use the Software for any commercial purpose\n" +
                    "- Allow any third party to use the Software on behalf of or for the benefit of any third party\n" +
                    "- Use the Software in any way which breaches any applicable local, national or international law\n" +
                    "- use the Software for any purpose that FreeGiving considers is a breach of this EULA agreement\n" +
                    
                    
                    "\nIntellectual Property and Ownership\n\n" +
                    
                    "FreeGiving shall at all times retain ownership of the Software as originally downloaded by you and all subsequent downloads of the Software by you. The Software (and the copyright, and other intellectual property rights of whatever nature in the Software, including any modifications made thereto) are and shall remain the property of FreeGiving.\n" +
                    
                    "FreeGiving reserves the right to grant licences to use the Software to third parties.\n" +
                    
                    "\nTermination\n\n" +
                    
                    "This EULA agreement is effective from the date you first use the Software and shall continue until terminated.\n" +
                    
                    "It will also terminate immediately if you fail to comply with any term of this EULA agreement. Upon such termination, the licenses granted by this EULA agreement will immediately terminate and you agree to stop all access and use of the Software. The provisions that by their nature continue and survive will survive any termination of this EULA agreement.\n" +
                    
                    "\nGoverning Law\n\n" +
                    
                    "This EULA agreement, and any dispute arising out of or in connection with this EULA agreement, shall be governed by and construed in accordance with the laws of Taiwan.\n" +
                    
                    "\nUser behavior\n\n" +
                    
                    "If user is flagged  with objectionable content, FreeGiving is authorized to block or delete abusive user in 24 hours without any approval.\n"
                    
                    , closeButtonTitle:"OK")

                print("Saved user successfully into Firebase db")

                self.mapViewController?.fetchUserAndSetupNavBarTitle()
                
                self.dismiss(animated: true, completion: nil)

            })

        })

    }

}
