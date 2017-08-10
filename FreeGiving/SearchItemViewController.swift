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
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
    }

    func handleOwnerProduct() {

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OwnerPage") as! OwnerProductTableViewController

        self.present(vc, animated: true, completion: nil)

    }
    
    func observePosts() {

        let userMessageRef = Database.database().reference().child("posts")

        userMessageRef.observe(.childAdded, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            
            let productPost = ProductPost()
            
            productPost.setValuesForKeys(dictionary)
            
            self.productPosts.append(productPost)
            
            self.collectionView?.reloadData()
            
        }, withCancel: nil)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return productPosts.count

    }
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: screenSize.width/2, height: screenSize.height/2)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PostCollectionViewCell
        
        cell.backgroundColor = UIColor.black
                
        cell.productPost = productPosts[indexPath.row]
        
        return cell
    }

}
