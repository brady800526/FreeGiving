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

    var postBeGiven = [String]()

    override func viewDidLoad() {

        observeUserGiven()
        
        fetchUserAndSetupNavBarTitle()

        self.navigationController?.navigationBar.barTintColor = UIColor.orange

        self.tableView.allowsSelection = false

        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.tableView.separatorStyle = .none
        
        self.tableView.rowHeight = UITableViewAutomaticDimension

    }

    func observeUserGiven() {

        let givenRef = Database.database().reference().child("givens")

        givenRef.observe(.value, with: { (snapshot) in

            self.postBeGiven = [String]()

            self.trackers = [String]()

            self.trackings = [PostStatus]()

            self.posts = [ProductPost]()

            guard let datasnapshot = snapshot.value as? [String: Any] else { return }

            for data in datasnapshot {

                self.postBeGiven.append(data.key)

            }

            self.observeUserTrackings()

        })

    }

    func observeUserTrackings() {

        let trackingRef = Database.database().reference().child("trackings")

        trackings = [PostStatus]()

        self.tableView.reloadData()

        trackingRef.observeSingleEvent(of: .value, with: { (snapshot) in

            for item in snapshot.children {

                guard let itemSnapshot = item as? DataSnapshot else { return }

                if let dictionary = itemSnapshot.value as? [String: Any] {

                    let tracking = PostStatus()

                    tracking.setValuesForKeys(dictionary)

                    if tracking.toId == Auth.auth().currentUser?.uid && tracking.checked == "true" && !self.postBeGiven.contains(tracking.postKey!) {

                        self.trackings.append(tracking)

                        trackingRef.observeSingleEvent(of: .value, with: { (_) in

                            trackingRef.child(itemSnapshot.key).updateChildValues(["checked": "false"])

                            DispatchQueue.main.async {

                                self.tableView.reloadData()

                            }

                        })

                        self.handleTrackers(tracking: tracking)

                        self.handlePost(tracking: tracking)

                    }

                    if tracking.toId == Auth.auth().currentUser?.uid && tracking.checked == "false" && !self.postBeGiven.contains(tracking.postKey!) {

                        self.trackings.append(tracking)

                        self.handleTrackers(tracking: tracking)

                        self.handlePost(tracking: tracking)

                    }

                }

            }

        })

    }

    func handleTrackers(tracking: PostStatus) {

        let userRef = Database.database().reference().child("users")

        userRef.child(tracking.fromId!).observeSingleEvent(of: .value, with: { (snapshot) in

            guard let dictionary = snapshot.value as? [String: Any] else { return }

            guard let name = dictionary["name"] as? String else { return }

            self.trackers.append(name)

            DispatchQueue.main.async {

                self.tableView.reloadData()

            }

        })

    }

    func handlePost(tracking: PostStatus) {

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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return trackers.count > posts.count ? posts.count : trackers.count

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! OwnerPostCell
        // swiftlint:enable force_cast

        cell.postImage.sd_setImage(with: URL(string: posts[indexPath.row].productImageURL!), placeholderImage: nil)

        cell.postImage.layer.shadowColor = UIColor.black.cgColor

        cell.postImage.layer.shadowOpacity = 0.5

        cell.postImage.layer.shadowRadius = 3

        cell.postImage.layer.shadowOffset = CGSize(width: 1, height: 1)

        cell.trackerNameLabel.text = trackers[indexPath.row]

        cell.trackerNameLabel.textColor = UIColor.orange

        cell.backgroundColor = UIColor.white

        cell.postMessage.text = trackings[indexPath.row].attention
        
        cell.deal.layer.cornerRadius = cell.deal.frame.width/2
        
        cell.deal.layer.shadowOpacity = 1
        
        cell.deal.layer.shadowOffset = CGSize(width: 3, height: 3)

        cell.tracking = trackings[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return self.view.bounds.height/3

    }
    
    func fetchUserAndSetupNavBarTitle() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any]
            {
                self.navigationItem.title = dictionary["name"] as? String
            }
            
        }, withCancel: nil)
    }

}
