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
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
//        observeMessages()user
        
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        
        observeUserMessages()
        
    }
    
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    
    func observeUserMessages() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference().child("user-messages").child(uid)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let messageId = snapshot.key
            
            let messageReference = Database.database().reference().child("messages").child(messageId)
            
            messageReference.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: Any] {
                    
                    let message = Message()
                    
                    message.setValuesForKeys(dictionary)
                    
                    print(message.text!)
                    
                    self.messages.append(message)
                    
                    if let toId = message.toId {
                        self.messagesDictionary[toId] = message
                        self.messages = Array(self.messagesDictionary.values)
                        self.messages.sort(by: { (message1, message2) -> Bool in
                            return (message1.timestamp?.intValue)! > (message2.timestamp?.intValue)!
                        })
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }

                }
                
            }, withCancel: nil)

            
        }, withCancel: nil)
        
        
    }
    
    func observeMessages() {
        
        let ref = Database.database().reference().child("messages")
        
        ref.observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any] {
                
                let message = Message()
                
                message.setValuesForKeys(dictionary)
                
                print(message.text!)
                
                self.messages.append(message)
                
                if let toId = message.toId {
                    self.messagesDictionary[toId] = message
                    self.messages = Array(self.messagesDictionary.values)
                    self.messages.sort(by: { (message1, message2) -> Bool in
                        return (message1.timestamp?.intValue)! > (message2.timestamp?.intValue)!
                    })
                }
                
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let message = messages[indexPath.row]
        
        guard let chatPartnerId = message.chatPartnerId() else { return }
        
        let ref = Database.database().reference().child("users").child(chatPartnerId)
        
        ref.observe(.value, with: { (snapshot) in
            
            print(snapshot)
            
            guard let dictionary = snapshot.value as? [String: AnyObject]
            else {
                return
            }
            
            let user = User()
            user.id = chatPartnerId
            user.setValuesForKeys(dictionary)
            self.showChatControllerForUser(user: user)
            
        }, withCancel: nil)
        
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

