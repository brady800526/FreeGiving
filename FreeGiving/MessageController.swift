//
//  newMessageTableViewController.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/8/6.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class MessageController: UITableViewController {

    let cellId = "cellId"

    override func viewDidLoad() {

        self.navigationController?.navigationBar.barTintColor = UIColor.orange

//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "mes", style: .plain, target: self, action: #selector(handleNewMessage))

        fetchUserAndSetupNavBarTitle()
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)

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

        ref.observe(.childAdded, with: { (snapshot) in

            let messageId = snapshot.key

            let messageReference = Database.database().reference().child("messages").child(messageId)

            messageReference.observeSingleEvent(of: .value, with: { (snapshot) in

                if let dictionary = snapshot.value as? [String: Any] {

                    let message = Message()

                    message.setValuesForKeys(dictionary)

                    self.messages.append(message)

                    if let chatPartnerId = message.chatPartnerId() {
                        self.messagesDictionary[chatPartnerId] = message
                        self.messages = Array(self.messagesDictionary.values)
                        self.messages.sort(by: { (message1, message2) -> Bool in
                            return (message1.timestamp?.intValue)! > (message2.timestamp?.intValue)!
                        })
                    }

                    self.timer?.invalidate()
                    self.timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)

                }

            }, withCancel: nil)

        }, withCancel: nil)

    }

    var timer: Timer?

    func handleReloadTable() {

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return messages.count

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        // swiftlint:enable force_cast

        let message = messages[indexPath.row]

        cell.message = message

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let message = messages[indexPath.row]

        guard let chatPartnerId = message.chatPartnerId() else { return }

        let ref = Database.database().reference().child("users").child(chatPartnerId)

        ref.observe(.value, with: { (snapshot) in

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
        let newMessage = FriendController()
        newMessage.messageController = self
        let nv = UINavigationController(rootViewController: newMessage)
        present(nv, animated: true)
    }

    func showChatControllerForUser(user: User) {
        let vc = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        vc.user = user
        let nv = UINavigationController(rootViewController: vc)
        present(nv, animated: true)
    }
    
    func fetchUserAndSetupNavBarTitle() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any]
            {
                self.navigationItem.title = dictionary["name"] as? String
            }
            
        }, withCancel: nil)
    }
}
