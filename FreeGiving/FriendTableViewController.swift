//
//  myTableViewController.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/8/2.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

import UIKit
import Firebase

class FriendTableViewController: UITableViewController {

    let cellid = "cellid"
    
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellid)
        
        fetchUser()
        
        let button =  UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        button.backgroundColor = UIColor.red
        button.setTitle("Button", for: .normal)
        button.addTarget(self, action: #selector(showChatController), for: .touchUpInside)
        self.navigationItem.titleView = button
    }
    
    func showChatController() {
        let chatLogController = ChatLogTableController(collectionViewLayout: UICollectionViewFlowLayout())
        let nav = UINavigationController(rootViewController: chatLogController)
        present(nav, animated: true)
    }
    
    func fetchUser() {
        
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User()
                user.setValuesForKeys(dictionary)
                print(user.name, user.email)
                self.users.append(user)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
            
        })
        
    }
    
    func handleCancel() {
        navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
//        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellid)
     
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath)
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        return cell
        
    }
}

class UserCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
