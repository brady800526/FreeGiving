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

class SearchItemController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    var productPosts: [ProductPost] = [] {

        didSet {
            
            filteredProducts = productPosts
            
        }

    }
    
    var filteredProducts: [ProductPost] = []
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        self.collectionView!.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        observePosts()
        
        setupCVLayout()

        setupSearchBar()
        
        handleLatest()
        
        }

    let searchBar = UISearchBar()
    
    func setupSearchBar() {
        
        searchBar.showsCancelButton = false
        
        searchBar.placeholder = "Enter your search here"
        
        searchBar.delegate = self
        
        navigationItem.titleView = searchBar
        
    }
    
    func setupCVLayout() {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        layout.minimumInteritemSpacing = 0
        
        layout.minimumLineSpacing = 0
        
        collectionView!.collectionViewLayout = layout

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

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return filteredProducts.count

    }
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: screenSize.width/2, height: screenSize.height/2)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PostCollectionViewCell
        
        cell.backgroundColor = UIColor.black
                
        cell.productPost = filteredProducts[indexPath.row]
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredProducts = searchText.isEmpty ? productPosts : productPosts.filter({ (product: ProductPost) -> Bool in
            
            return product.productName?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            
        })
        
        collectionView?.reloadData()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.showsCancelButton = false

        searchBar.text = ""

        searchBar.resignFirstResponder()
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let user = User()

        user.id = filteredProducts[indexPath.row].user
        
        let ref = Database.database().reference().child("users").child(user.id!)

        
        ref.observe(.value, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String: AnyObject]
                else {
                    return
            }
            user.setValuesForKeys(dictionary)
            self.showChatControllerForUser(user: user)
            
        }, withCancel: nil)

    }

    func showChatControllerForUser(user: User) {
        let vc = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        vc.user = user
        let nv = UINavigationController(rootViewController: vc)
        present(nv, animated: true)
    }
    
}
