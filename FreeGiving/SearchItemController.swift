//
//  SearchItemViewController.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/7/28.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

import UIKit
import Firebase

private let searchCell = "Cell"

class SearchItemController: UICollectionViewController {

    var productPosts: [ProductPost] = [] {

        didSet {
            
            filteredProducts = productPosts
            
        }

    }
    
    var filteredProducts: [ProductPost] = []
    
    let searchBar = UISearchBar()
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        self.collectionView!.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: searchCell)
        
        observePosts()
        
        handleLatest()
        
        setupCVLayout()

        setupSearchBar()
        
        }
    
    func handleLatest() {
        
        filteredProducts.sort { (product1, product2) -> Bool in
            
            return Int(product1.timeStamp!) > Int(product2.timeStamp!)
            
        }
        
        self.collectionView?.reloadData()
        
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
    
}
