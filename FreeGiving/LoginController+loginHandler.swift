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

                SCLAlertView().showError("SIGN IN ERROR", subTitle:error.localizedDescription, closeButtonTitle:"OK")

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

                SCLAlertView().showError("REGISTER ERROR", subTitle:error.localizedDescription, closeButtonTitle:"OK")
                return
            }

            guard

                let uid = user?.uid

                else {

                    return

            }
            
            self.showDeclaimAlertView(declaim: .endUserLicenceAgreement)
            
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
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        switch URL.absoluteString {
            
        case Declaim.termsOfService.rawValue:
            
            showDeclaimAlertView(declaim: .termsOfService)
            
        case Declaim.privacyPolicy.rawValue:
            
            showDeclaimAlertView(declaim: .privacyPolicy)
            
        default: break
            
        }
        
        return true
    }
    
    func showDeclaimAlertView(declaim: Declaim) {
        
        let appearance = SCLAlertView.SCLAppearance(
            
            kWindowWidth: UIScreen.main.bounds.width * 0.9,
            
            kWindowHeight: UIScreen.main.bounds.height * 0.9
        )

        let alertView = SCLAlertView(appearance: appearance)
        
        let declaimRtfPath = Bundle.main.url(forResource: declaim.rawValue, withExtension: "rtf")!
        
        let attributedStringWithRtf = try! NSAttributedString(
            url: declaimRtfPath,
            options: [NSDocumentTypeDocumentAttribute : NSRTFTextDocumentType],
            documentAttributes: nil)
        
        var declaimTitle: String = ""
        
        switch declaim {
            
        case .endUserLicenceAgreement:
            
            declaimTitle = "End-User License Agreement"
            
        case .termsOfService:
            
            declaimTitle = "Terms Of Service"
            
        case .privacyPolicy:
            
            declaimTitle = "Privacy policy"

        }
        
        alertView.setAlignmentLeft()
        alertView.showInfo(declaimTitle,
                          subTitle: attributedStringWithRtf.string,
                          closeButtonTitle:"Agree"
        )
    }

}
