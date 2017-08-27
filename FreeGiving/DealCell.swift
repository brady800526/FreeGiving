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

class DealCell: UITableViewCell {

    var tracking: PostStatus?
    var post: ProductPost?

    let productImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    let productTrackerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Label"
        label.font = UIFont(name: "Marker Felt", size: 24)
        label.textAlignment = .center
        return label
    }()

    let productTrackerAttentionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont(name: "Marker Felt", size: 20)
        label.textAlignment = .center
        return label
    }()

    lazy var productDeal: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(deal), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "deal"), for: .normal)
        button.tintColor = UIColor.white
        button.backgroundColor = UIColor.orange
        return button
    }()

    func deal() {
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

            })

        }
        alert.addButton("No") {
            return
        }

        alert.showWarning("Notice", subTitle: "Are you sure you want to give this product to \(String(describing: productTrackerLabel.text!))")

    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        self.contentView.addSubview(productImageView)
        self.contentView.addSubview(productTrackerLabel)
        self.contentView.addSubview(productTrackerAttentionLabel)
        self.contentView.addSubview(productDeal)

        productImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 8).isActive = true
        productImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8).isActive = true
        productImageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 1/2, constant: -16).isActive = true
        productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor, multiplier: 1).isActive = true
        productImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8).isActive = true

        productTrackerLabel.leftAnchor.constraint(equalTo: productImageView.rightAnchor, constant: 8).isActive = true
        productTrackerLabel.topAnchor.constraint(equalTo: productImageView.topAnchor).isActive = true
        productTrackerLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true

        productTrackerAttentionLabel.topAnchor.constraint(equalTo: productTrackerLabel.bottomAnchor, constant: 8).isActive = true
        productTrackerAttentionLabel.leftAnchor.constraint(equalTo: productImageView.rightAnchor, constant: 8).isActive = true
        productTrackerAttentionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        productTrackerAttentionLabel.bottomAnchor.constraint(lessThanOrEqualTo: productDeal.topAnchor).isActive = true

        productDeal.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 0).isActive = true
        productDeal.bottomAnchor.constraint(equalTo: self.productImageView.bottomAnchor, constant: 0).isActive = true
        productDeal.heightAnchor.constraint(equalTo: self.productDeal.widthAnchor).isActive = true
        productDeal.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 1/7).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
