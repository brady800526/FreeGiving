//
//  newMessageTableViewController.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/8/6.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

import Foundation
import UIKit
import Firebase

private let cellId = "cellId"

class OwnerController: UITableViewController {
    
    override func viewDidLoad() {
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)

        observeUserTrackings()
        
    }
    
    var trackings = [PostStatus]()
    
    var posts = [ProductPost]()
    
//    var messagesDictionary = [String: Message]()
    
    func observeUserTrackings() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }

        print(uid)
        
        let trackingRef = Database.database().reference().child("trackings")
        
        trackingRef.observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any] {
                
                let tracking = PostStatus()
                
                tracking.setValuesForKeys(dictionary)
                
                if tracking.toId == Auth.auth().currentUser?.uid {
                    
                    self.trackings.append(tracking)
                    
                    let postRef = Database.database().reference().child("posts")
                    
                    postRef.child(tracking.postKey!).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        guard let dictionary = snapshot.value as? [String: Any] else { return }
                        
                        let post = ProductPost()
                        
                        post.setValuesForKeys(dictionary)
                        
                        self.posts.append(post)
                        
                        DispatchQueue.main.async {
                            
                            self.tableView.reloadData()
                            
                        }

                    })
                    
                }
                
            }
            
        })
        
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)

        cell.backgroundColor = UIColor.black
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let message = messages[indexPath.row]
//        
//        guard let chatPartnerId = message.chatPartnerId() else { return }
//        
//        let ref = Database.database().reference().child("users").child(chatPartnerId)
//        
//        ref.observe(.value, with: { (snapshot) in
//            
//            guard let dictionary = snapshot.value as? [String: AnyObject]
//                else {
//                    return
//            }
//            
//            let user = User()
//            
//            user.id = chatPartnerId
//            
//            user.setValuesForKeys(dictionary)
//
//        }, withCancel: nil)
        
    }

}

