//
//  OwnerPostCell.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/8/14.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

import UIKit

class OwnerPostCell: UITableViewCell {
    
    var tracking: PostStatus?
    var post: ProductPost?
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var trackerNameLabel: UILabel!

}
