//
//  SearchItemController.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/8/10.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

import UIKit

extension SearchItemController: UISearchBarDelegate {

    func setupSearchBar() {

        searchBar.placeholder = "Enter your search here"

        searchBar.delegate = self

        navigationItem.titleView = searchBar

    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

        searchBar.showsCancelButton = false

        searchBar.text = ""

        searchBar.resignFirstResponder()

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        filteredProducts = searchText.isEmpty ? productPosts : productPosts.filter({ (product: ProductPost) -> Bool in

            return product.title?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil

        })

        collectionView?.reloadData()

    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {

        self.searchBar.showsCancelButton = true

    }

}
