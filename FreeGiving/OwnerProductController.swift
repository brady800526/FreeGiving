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
import SDWebImage

class OwnerController: UITableViewController {
    
    override func viewDidLoad() {

        observeUserTrackings()
        
//        observeUserChangings()
        
    }
    
    var trackings = [PostStatus]()
    
    var posts = [ProductPost]()
    
    var trackers = [String]()

    func observeUserTrackings() {

        trackings = [PostStatus]()
        
        posts = [ProductPost]()
        
        trackers = [String]()
        
        let trackingRef = Database.database().reference().child("trackings")
        
        trackingRef.observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any] {
                
                let tracking = PostStatus()
                
                tracking.setValuesForKeys(dictionary)
                
                if tracking.toId == Auth.auth().currentUser?.uid && tracking.checked == "false" {
                    
                    self.trackings.append(tracking)
                    
                    let userRef = Database.database().reference().child("users")
                    
                    userRef.child(tracking.fromId!).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        guard let dictionary = snapshot.value as? [String: Any] else { return }
                        
                        let user = User()
                        
                        user.setValuesForKeys(dictionary)
                        
                        self.trackers.append(user.name!)
                        
                        DispatchQueue.main.async {
                            
                            self.tableView.reloadData()
                            
                        }
                        
                    })
                    
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
    
//    func observeUserChangings() {
//        
//        var filtertrackings = [PostStatus]()
//        
//        var filterposts = [ProductPost]()
//        
//        var filtertrackers = [String]()
//        
//        let ref = Database.database().reference()
//        
//        let trackRef = ref
//        
//        trackRef.observe(.childChanged, with: { (snapshot) in
//
//            guard let dictionary = snapshot.value as? [String: Any] else { return }
//            
//            for item in dictionary as [String: Any] {
//            
//                let tracking = PostStatus()
//                
//                tracking.setValuesForKeys(item.value as! [String: Any])
//                
//                if tracking.checked == "false" && tracking.toId == Auth.auth().currentUser?.uid {
//                    
//                    filtertrackings.append(tracking)
//                    
//                    self.trackings = filtertrackings
//                    
//                    let userRef = Database.database().reference().child("users")
//                    
//                    userRef.child(tracking.fromId!).observeSingleEvent(of: .value, with: { (snapshot) in
//                        
//                        guard let dictionary = snapshot.value as? [String: Any] else { return }
//                        
//                        let user = User()
//                        
//                        user.setValuesForKeys(dictionary)
//                        
//                        filtertrackers.append(user.name!)
//                        
//                        self.trackers = filtertrackers
//                        
//                        DispatchQueue.main.async {
//                            
//                            self.tableView.reloadData()
//                            
//                        }
//                        
//                    })
//                    
//                    let postRef = Database.database().reference().child("posts")
//                    
//                    postRef.child(tracking.postKey!).observeSingleEvent(of: .value, with: { (snapshot) in
//                        
//                        guard let dictionary = snapshot.value as? [String: Any] else { return }
//                        
//                        let post = ProductPost()
//                        
//                        post.setValuesForKeys(dictionary)
//                        
//                        filterposts.append(post)
//                        
//                        self.posts = filterposts
//                        
//                    })
//                    
//                }
//                
//            }
////                        
//        })
//
//                    let postRef = Database.database().reference().child("posts")
//                    
//                    postRef.child(tracking.postKey!).observeSingleEvent(of: .value, with: { (snapshot) in
//                        
//                        guard let dictionary = snapshot.value as? [String: Any] else { return }
//                        
//                        let post = ProductPost()
//                        
//                        post.setValuesForKeys(dictionary)
//                        
//                        self.posts.append(post)
//                        
//                        
//                    })
//                    
//                }
//                
//            }
//
//            
//        })  
//        
//    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count > trackers.count ? posts.count : trackers.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! OwnerPostCell
        
        cell.postImage.sd_setImage(with: URL(string: posts[indexPath.row].productImageURL!), placeholderImage: nil)
        
//        cell.trackerNameLabel.text = trackers[indexPath.row]
        
        cell.trackerNameLabel.textColor = UIColor.white
        
        cell.tracking = trackings[indexPath.row]
        
        cell.post = posts[indexPath.row]

        cell.backgroundColor = UIColor.black
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 200
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let trackingRef = Database.database().reference().child("trackings")

        trackingRef.observe(.childAdded, with: {(snapshot) in
        
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            
            let postStatus = PostStatus()
            
            postStatus.setValuesForKeys(dictionary)

            if postStatus.postKey == self.trackings[indexPath.row].postKey && postStatus.fromId == self.trackings[indexPath.row].fromId {

                trackingRef.child(snapshot.key).updateChildValues(["checked": "true"])

            }

        })

    }

}

