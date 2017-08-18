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
    
    var trackings = [PostStatus]()
    
    var posts = [ProductPost]()
    
    var trackers = [String]()
    
    var reload = false
    
    var postBeGiven = [String]()
    
    override func viewDidLoad() {
        
        observeUserGiven()
        
        observeUserTrackings()

        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
    }
    
    func observeUserGiven() {
        
        let givenRef = Database.database().reference().child("givens")
        
        givenRef.observe( .childAdded, with: { (snapshot) in
            
        self.postBeGiven.append(snapshot.key)
            
        })
        
    }
    
    func observeUserTrackings() {
        
        let trackingRef = Database.database().reference().child("trackings")
        
        trackingRef.observe(.value, with: { (snapshot) in
            
            if self.reload == true {
                
                self.trackings = [PostStatus]()
                
                self.trackers = [String]()
                
                self.posts = [ProductPost]()
                
            }
            
            for item in snapshot.children {
                
                guard let itemSnapshot = item as? DataSnapshot else { return }
                
                if let dictionary = itemSnapshot.value as? [String: Any] {
                    
                    let tracking = PostStatus()
                    
                    tracking.setValuesForKeys(dictionary)
                    
                    print(tracking.toId, Auth.auth().currentUser?.uid)
                    
                    print(tracking.checked, "false")
                    
                    print(tracking.postKey!, self.postBeGiven)
                    
                    if tracking.toId == Auth.auth().currentUser?.uid && tracking.checked == "false" && !self.postBeGiven.contains(tracking.postKey!) {
                        
                        self.trackings.append(tracking)
                        
                        let userRef = Database.database().reference().child("users")
                        
                        userRef.child(tracking.fromId!).observeSingleEvent(of: .value, with: { (snapshot) in
                            
                            guard let dictionary = snapshot.value as? [String: Any] else { return }
                            
                            self.trackers.append(dictionary["name"] as! String)
                            
                            let postRef = Database.database().reference().child("posts")
                            
                            postRef.child(tracking.postKey!).observeSingleEvent(of: .value, with: { (snapshot) in
                                
                                guard let dictionary = snapshot.value as? [String: Any] else { return }
                                
                                let post = ProductPost()
                                
                                post.setValuesForKeys(dictionary)
                                
                                self.posts.append(post)
                                
                                DispatchQueue.main.async {
                                    
                                    self.tableView.reloadData()
                                    
                                    return
                                    
                                }
                                
                            })
                            
                        })
                        
                    }
                    
                }
                
            }
            
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
                
                return
            }
            
        })
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(posts.count)
        
        return posts.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! OwnerPostCell
        
        cell.postImage.sd_setImage(with: URL(string: posts[indexPath.row].productImageURL!), placeholderImage: nil)
        
        cell.postImage.layer.shadowColor = UIColor.black.cgColor
        
        cell.postImage.layer.shadowOpacity = 0.5
        
        cell.postImage.layer.shadowRadius = 3
        
        cell.postImage.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        cell.trackerNameLabel.text = trackers[indexPath.row]
        
        cell.trackerNameLabel.textColor = UIColor.orange
        
        cell.backgroundColor = UIColor.white
        
        cell.postMessage.text = trackings[indexPath.row].attention
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let trackingRef = Database.database().reference().child("trackings")
        
        trackingRef.observeSingleEvent(of: .value, with: {(snapshot) in
            
            guard let value = snapshot.value as? [String: Any] else { return }
            
            for item in value {
                
                print(item.value)
                
                let postStatus = PostStatus()
                
                postStatus.setValuesForKeys(item.value as! [String : Any])
                
                if postStatus.postKey == self.trackings[indexPath.row].postKey && postStatus.fromId == self.trackings[indexPath.row].fromId {
                    
                    trackingRef.child(item.key).updateChildValues(["checked": "true"])
                    
                    self.reload = true
                    
                }
                
            }
            
            let givenRef = Database.database().reference().child("givens")
            
            givenRef.updateChildValues([self.trackings[indexPath.row].postKey!: 1])
            
            self.postBeGiven.append(self.trackings[indexPath.row].postKey!)
            
        })
        
    }
    
}

