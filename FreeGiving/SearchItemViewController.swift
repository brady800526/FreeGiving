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

class SearchItemCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var productPosts: [ProductPost] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Owner", style: .plain, target: self, action: #selector(handleOwnerProduct))
        
        self.collectionView!.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        observePosts()
    }

    func handleOwnerProduct() {

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OwnerPage") as! OwnerProductTableViewController

        self.present(vc, animated: true, completion: nil)

    }
    
    func observePosts() {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            
            return
            
        }
        
        let userMessageRef = Database.database().reference().child("posts")

        userMessageRef.observe(.childAdded, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            
            let productPost = ProductPost()
            
            productPost.setValuesForKeys(dictionary)
            
            self.productPosts.append(productPost)
            
            self.collectionView?.reloadData()
            
        }, withCancel: nil)
    }

    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return productPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 115, height: 200)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PostCollectionViewCell
        
        cell.backgroundColor = UIColor.black
        
        let productPost = productPosts[indexPath.row]
        
        cell.productPost = productPosts[indexPath.row]
        
        return cell
    }

}
