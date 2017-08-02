//
//  ChatLogTableController.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/8/2.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

import UIKit

class ChatLogTableController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Chat Log Controlller"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "back", style: .plain, target: self, action: #selector(handleDismiss))
        
        collectionView?.backgroundColor = UIColor.white
        
        setupInputComponent()
    }
    
    func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }

    func setupInputComponent() {

        let containerView = UIView()
        containerView.backgroundColor = UIColor.red
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let sendButton = UIButton(type: .system)
        
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(sendButton)
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let inputTextField = UITextField()
        inputTextField.placeholder = "Enter message..."
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(inputTextField)
        
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.widthAnchor.constraint(equalToConstant: 100).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
    }
}
