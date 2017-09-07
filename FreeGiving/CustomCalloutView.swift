//
//  CustomCalloutView.swift
//  CustomCalloutView
//
//  Created by Malek T. on 3/10/16.
//  Copyright © 2016 Medigarage Studios LTD. All rights reserved.
//

import UIKit
import Firebase
import BEMCheckBox
import SCLAlertView

class CustomCalloutView: UIView {

    @IBOutlet var postImage: UIImageView!
    @IBOutlet var postTitle: UILabel!
    @IBOutlet var postTime: UILabel!
    @IBOutlet var postDescription: UILabel!
    @IBOutlet weak var chat: UIButton!
    @IBOutlet weak var checkBox: BEMCheckBox!
    @IBOutlet weak var flagImageView: UIImageView!
    

    var mapVC: MapController?

    var userId: String?

    var post: Post? {

        didSet {

            chat.tintColor = UIColor.orange
            postTitle.text = post?.title
            postDescription.text = post?.productDescription

            if let seconds = post?.timeStamp?.doubleValue {
                let timestampDate = NSDate(timeIntervalSince1970: seconds)

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM dd, yyyy"
                postTime.text = dateFormatter.string(from: timestampDate as Date)
                postTime.textColor = UIColor.lightGray
            }

            //
//            let button = UIButton(frame: calloutView.starbucksPhone.frame)
            //        button.addTarget(self, action: #selector(ViewController.callPhoneNumber(sender:)), for: .touchUpInside)
//            calloutView.addSubview(button)

            postImage.sd_setImage(with: URL(string: (post?.productImageURL!)!), placeholderImage: nil)

            userId = post?.user

            let ref = Database.database().reference()

            ref.child("trackings").observeSingleEvent(of: .value, with: { (snapshot) in

                for item in snapshot.children {

                    guard let itemSnapshot = item as? DataSnapshot else { return }

                    guard let dictionary = itemSnapshot.value as? [String: Any] else { return }

                    let postStatus = PostStatus()

                    postStatus.setValuesForKeys(dictionary)

                    if postStatus.fromId == Auth.auth().currentUser?.uid && postStatus.toId == self.userId && postStatus.checked == "false" && postStatus.postKey == self.post?.key {

                        self.checkBox.onAnimationType = .stroke

                        self.checkBox.on = true

                        return

                    } else {

                        self.checkBox.offAnimationType = .stroke

                        self.checkBox.on = false

                    }

                }

            })

            flagImageView.image = flagImageView.image?.withRenderingMode(.alwaysTemplate)
            flagImageView.tintColor = UIColor.white
            flagImageView.layer.shadowOpacity = 1
            flagImageView.layer.shadowOffset = CGSize(width: 1, height: 1)
            flagImageView.clipsToBounds = false
            flagImageView.layer.shadowColor = UIColor.black.cgColor
        }

    }

    @IBAction func chat(_ sender: Any) {

        Analytics.logEvent("chat_giver", parameters: nil)

        let user = User()

        let ref = Database.database().reference()

        ref.child("users").child(userId!).observeSingleEvent(of: .value, with: { (snapshot) in

            if let dictionary = snapshot.value as? [String:Any] {

                user.setValuesForKeys(dictionary)

                print(self.userId!)

                print(snapshot.value!)

                user.id = snapshot.key

                self.showChatControllerForUser(user: user)

            }

        }, withCancel: nil)

    }

    @IBAction func check(_ sender: Any) {

        let ref = Database.database().reference()

        ref.child("trackings").observeSingleEvent(of: .value, with: { (snapshot) in

            var foundEvent = true

            for item in snapshot.children {

                guard let itemSnapshot = item as? DataSnapshot else { return }

                guard let dictionary = itemSnapshot.value as? [String: Any] else { return }

                let postStatus = PostStatus()

                postStatus.setValuesForKeys(dictionary)

                if postStatus.fromId == Auth.auth().currentUser?.uid && postStatus.toId == self.userId && postStatus.checked == "false" && postStatus.postKey == self.post?.key {

                    ref.child("trackings").child(itemSnapshot.key).removeValue()

                    let appearance = SCLAlertView.SCLAppearance()

                    _ = SCLAlertView(appearance: appearance).showSuccess("Cacnel Subscription", subTitle: "You just cancel your subscription to \(String(describing: (self.post?.title)!))")

                    Analytics.logEvent("desubscribe_giverItem", parameters: nil)

                    self.checkBox.offAnimationType = .stroke

                    self.checkBox.on = false

                    return

                } else {

                    foundEvent = false

                }

            }

            if foundEvent == false {

                let trackingRef = ref.child("trackings").childByAutoId()

                let appearance = SCLAlertView.SCLAppearance(
                    showCloseButton: false
                )

                let alert = SCLAlertView(appearance: appearance)
                let txt = alert.addTextField("Say something to giver")
                _ = alert.addButton("Send") {

                    guard let uid = Auth.auth().currentUser?.uid,
                        let userId = self.userId,
                        let key = self.post?.key else { return }

                    let values = ["fromId": uid, "toId": userId, "postKey": key, "checked": "false", "timeStamp": NSNumber(value: Date().timeIntervalSinceReferenceDate), "attention": txt.text ?? "NA"] as [String : Any]

                    trackingRef.updateChildValues(values)

                }
                _ = alert.showSuccess("Success Subscription", subTitle:"After subscribe to \(String(describing: (self.post?.title)!)), wait notification from giver")

                Analytics.logEvent("subscribe_giverItem", parameters: nil)

                self.checkBox.onAnimationType = .stroke

                self.checkBox.on = true

            }

        })

    }

    func showChatControllerForUser(user: User) {

        let vc = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())

        vc.user = user

        let nv = UINavigationController(rootViewController: vc)

        mapVC?.present(nv, animated: true)
    }

    @IBAction func flag(_ sender: Any) {
        
        let optionMenu = UIAlertController(title: nil, message: "Flag this post because objectionable content", preferredStyle: .alert)

        let flagAction = UIAlertAction(title: "Yes", style: .destructive, handler: {
            (alert: UIAlertAction!) -> Void in
            
            let warningMenu = UIAlertController(title: nil, message: "This post content will be proccessed within 24 hour", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: {
                (alert: UIAlertAction!) -> Void in
            })
            
            warningMenu.addAction(OKAction)
            
            self.mapVC?.present(warningMenu, animated: true, completion: nil)
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        optionMenu.addAction(flagAction)
        optionMenu.addAction(cancelAction)
        
        mapVC?.present(optionMenu, animated: true, completion: nil)
        
    }
}
