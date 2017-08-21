//
//  OwnerPostCell.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/8/14.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView

class OwnerPostCell: UITableViewCell {

    var tracking: PostStatus?
    var post: ProductPost?

    @IBOutlet weak var deal: UIButton!

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var trackerNameLabel: UILabel!
    @IBOutlet weak var postMessage: UITextView!

    @IBAction func deal(_ sender: Any) {

        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)

        let alert = SCLAlertView(appearance: appearance)

        alert.addButton("Yes") {

            let trackingRef = Database.database().reference().child("trackings")

            trackingRef.observeSingleEvent(of: .value, with: {(snapshot) in

                guard let value = snapshot.value as? [String: Any] else { return }

                for item in value {

                    let postStatus = PostStatus()

                    guard let dictionary = item.value as? [String: Any] else { return }

                    postStatus.setValuesForKeys(dictionary)

                    if postStatus.postKey == self.tracking?.postKey && postStatus.fromId == self.tracking?.fromId {

                        trackingRef.child(item.key).updateChildValues(["checked": "true"])

                    }

                }

                let givenRef = Database.database().reference().child("givens")

                givenRef.updateChildValues([(self.tracking?.postKey)!: 1])

//                let postsRef = Database.database().reference().child("posts")
//
//                postsRef.child((self.tracking?.postKey)!).updateChildValues(["available": "false"])
//
            })

        }
        alert.addButton("No") {
            return
        }

        alert.showWarning("Notice", subTitle: "Are you sure you want to give this product to \(String(describing: trackerNameLabel.text!))")

    }
}
