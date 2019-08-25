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
import AnimatedGradientView

class ChattingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var messageTableView: UITableView!
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    
    var messageArray : [Message] = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        //Set up table view
        messageTableView.separatorStyle = .none
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTextField.delegate = self
        messageTableView.register(UINib(nibName: "CustomMessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        configureTableView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        
        retrieveMessages()
    }
    
    //Go back to previous view when button pressed
    @IBAction func logOutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        }
        catch {
            print("Error")
        }
    }
    
    //MARK: - table view editing and using custom cells
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        cell.messageBody.text = messageArray[indexPath.row].message
        cell.senderUsername.text = messageArray[indexPath.row].sender
     
        //Assign cell background gradient view and avatar color based on user
        if cell.senderUsername.text == Auth.auth().currentUser?.email as String? {
            
            let selfAnimatedGradient = AnimatedGradientView(frame: view.bounds)
            selfAnimatedGradient.animationValues = [(colors: ["#a0ceef", "#7F7FD5"], .up, .axial),
                                                    (colors: ["#7F7FD5", "#a0ceef"], .right, .axial)]
            
            cell.animatedView.addSubview(selfAnimatedGradient)
            cell.avatarImageview.backgroundColor = UIColor(hexString: "#7F7FD5")!
        }
        else {
            
            let othersAnimatedGradient = AnimatedGradientView(frame: view.bounds)
            othersAnimatedGradient.animationValues = [(colors: ["#EF629F", "#EECDA3"], .down, .axial),
                                                      (colors: ["#EECDA3", "#EF629F"], .left, .axial)]
            
            cell.animatedView.addSubview(othersAnimatedGradient)
            cell.avatarImageview.backgroundColor = UIColor(hexString: "#EF629F")!
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
    
    @objc func tableViewTapped() {
        messageTextField.endEditing(true)
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
            
            let indexPath = IndexPath(row: self.messageArray.count-1, section: 0)
            self.messageTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
}
