//
//  Message.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/8/6.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {

    var fromId: String?
    var toId: String?
    var timestamp: NSNumber?
    var text: String?
    
    func chatPartnerId() -> String? {
        
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId

    }
}
