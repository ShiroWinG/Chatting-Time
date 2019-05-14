//
//  ChattingViewController.swift
//  Chatting Time
//
//  Created by Zhi Wei Zhang on 4/18/19.
//  Copyright © 2019 Zhi Wei Zhang. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework

class ChattingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var messageArray : [Message] = [Message]()

    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var messageTableView: UITableView!
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        messageTableView.separatorStyle = .none

        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        messageTextField.delegate = self
        
        messageTableView.register(UINib(nibName: "CustomMessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        configureTableView()
        
        messageTextField.autocorrectionType = .no
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        
        retrieveMessages()
        
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        }
        catch {
            print("Error")
        }
    }
    
    //MARK: - text field UI editing
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.24) {
            self.heightConstraint.constant = 345
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.35) {
            self.heightConstraint.constant = 65
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func tableViewTapped() {
        messageTextField.endEditing(true)
    }
    
    //MARK: - table view editing and using custom cells
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        cell.messageBody.text = messageArray[indexPath.row].message
        cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.avatarImageview.backgroundColor = UIColor(hexString: "#EF629F")!

        if cell.senderUsername.text == Auth.auth().currentUser?.email as String? {
            
            cell.messageBackground.backgroundColor = UIColor(gradientStyle: UIGradientStyle.leftToRight, withFrame: cell.messageBackground.frame, andColors: [UIColor(hexString: "#7F7FD5")!, UIColor(hexString: "#86A8E7")!, UIColor(hexString: "#91EAE4")!])
            cell.avatarImageview.backgroundColor = UIColor(hexString: "#7F7FD5")!
            
        }
        else {
            
            cell.messageBackground.backgroundColor = UIColor(gradientStyle: UIGradientStyle.leftToRight, withFrame: cell.messageBackground.frame, andColors: [UIColor(hexString: "#EF629F")!, UIColor(hexString: "#EECDA3")!])
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messageArray.count
        
    }
    
    func configureTableView() {
        
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.estimatedRowHeight = 120
    }
    
    //MARK: - message related functions
    
    @IBAction func sendPressed(_ sender: Any) {
        
        messageTextField.endEditing(true)
        
        messageTextField.isEnabled = false
        sendButton.isEnabled = false
        
        let messagesDB = Database.database().reference().child("Messages")
        let messageDictionary = ["Sender": Auth.auth().currentUser?.email, "MessageBody": messageTextField.text!]
        
        messagesDB.childByAutoId().setValue(messageDictionary) {
            (error, reference) in
            if error != nil {
                print(error!)
            }
                
            else {
                print("Messaged saved")
                self.messageTextField.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextField.text = ""
            }
        }
    }
    
    func retrieveMessages() {
        
        let messageDB = Database.database().reference().child("Messages")
        
        messageDB.observe(.childAdded) { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
            
            let message = Message()
            message.sender = sender
            message.message = text
            
            self.messageArray.append(message)
            
            self.configureTableView()
            self.messageTableView.reloadData()
        }
    }
}

//TODO: Automize height change for different screen
//TODO: Sync keyboard animation
//TODO: maybe make message bubble fancy
//TODO: black navigation bar
