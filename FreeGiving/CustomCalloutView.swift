//
//  CustomCalloutView.swift
//  CustomCalloutView
//
//  Created by Malek T. on 3/10/16.
//  Copyright © 2016 Medigarage Studios LTD. All rights reserved.
//

import UIKit

class CustomCalloutView: UIView {

    @IBOutlet var starbucksImage: UIImageView!
    @IBOutlet var starbucksName: UILabel!
    @IBOutlet var starbucksAddress: UILabel!
    @IBOutlet var starbucksPhone: UILabel!
    
    var post: Post? {

        didSet {
            
            starbucksName.text = post?.title
            starbucksAddress.text = post?.productOnShelfTime
            starbucksPhone.text = post?.productDescription
            
            //
//            let button = UIButton(frame: calloutView.starbucksPhone.frame)
            //        button.addTarget(self, action: #selector(ViewController.callPhoneNumber(sender:)), for: .touchUpInside)
//            calloutView.addSubview(button)
            
            starbucksImage.sd_setImage(with: URL(string: (post?.productImageURL!)!), placeholderImage: nil)
        }

    }

}
