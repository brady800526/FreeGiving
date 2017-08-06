//
//  newMessageTableViewController.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/8/6.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

import UIKit
import Firebase

class newMessageTableViewController: UITableViewController {

    let cellId = "cellId"

    override func viewDidLoad() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "mess", style: .plain, target: self, action: #selector(handleNewMessage))
        
        let button =  UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        button.backgroundColor = UIColor.red
        button.setTitle("Button", for: .normal)
//        button.addTarget(self, action: #selector(showChatController), for: .touchUpInside)
        self.navigationItem.titleView = button
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        observeMessages()
        
    }
    
    var messages = [Message]()
    
    func observeMessages() {
        
        let ref = Database.database().reference().child("messages")
        
        ref.observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any] {
                
                let message = Message()
                
                message.setValuesForKeys(dictionary)
                
                print(message.text!)
                
                self.messages.append(message)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        }, withCancel: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messages.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let message = messages[indexPath.row]
        cell.message = message
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 72
        
    }
    
    func handleNewMessage() {
        let newMessage = FriendTableViewController()
        newMessage.messageController = self
        let nv = UINavigationController(rootViewController: newMessage)
        present(nv, animated: true)
    }
    
    func showChatControllerForUser(user: User) {
        let vc = ChatLogTableController(collectionViewLayout: UICollectionViewLayout())
        vc.user = user
        let nv = UINavigationController(rootViewController: vc)
        present(nv, animated: true)
    }
}

