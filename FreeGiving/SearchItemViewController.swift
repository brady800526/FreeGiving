//
//  SearchItemViewController.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/7/28.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

import UIKit
import Firebase

import UIKit

private let reuseIdentifier = "Cell"

class SearchItemCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Owner", style: .plain, target: self, action: #selector(handleOwnerProduct))
        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
//        observePosts()
    }

    func handleOwnerProduct() {

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OwnerPage") as! OwnerProductTableViewController

        self.present(vc, animated: true, completion: nil)

    }
    
    func observePosts() {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            
            return
            
        }
        
        let userMessageRef = Database.database().reference().child("user-messages").child(uid)
        userMessageRef.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            
            let messagesRef = Database.database().reference().child("messages").child(messageId)
            
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                print(snapshot)
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    
                    return
                    
                }
                
                let message = Message()
                
                message.setValuesForKeys(dictionary)
                
//                if message.chatPartnerId() == self.user?.id {
//                    
//                    self.messages.append(message)
//                    
//                    DispatchQueue.main.async {
//                        
//                        self.collectionView?.reloadData()
//                        
//                    }
//                }
                
                DispatchQueue.main.async {
                    
                    self.collectionView?.reloadData()
                    
                }
                
            }, withCancel: nil)
            
        }, withCancel: nil)
    }

    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        cell.backgroundColor = UIColor.black
        
        // Configure the cell
        
        return cell
    }

}
