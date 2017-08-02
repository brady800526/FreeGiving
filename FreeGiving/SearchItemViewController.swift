//
//  SearchItemViewController.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/7/28.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

import UIKit

class SearchItemViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Owner", style: .plain, target: self, action: #selector(handleOwnerProduct))

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Owner", style: .plain, target: self, action: #selector(handleOwnerProduct))
    }

    func handleOwnerProduct() {

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OwnerPage") as! OwnerProductTableViewController

        self.present(vc, animated: true, completion: nil)

    }

}
