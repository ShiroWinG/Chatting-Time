//
//  ChattingViewController.swift
//  Chatting Time
//
//  Created by Zhi Wei Zhang on 4/18/19.
//  Copyright © 2019 Zhi Wei Zhang. All rights reserved.
//

import UIKit
import Firebase

class ChattingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var messageTableView: UITableView!
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true

        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        messageTableView.register(UINib(nibName: "CustomMessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        configureTableView()
        
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
        let messageArray = ["Chungus", "Chungus2Chungus2Chungus2Chungus2Chungus2Chungus2Chungus2Chungus2Chungus2Chungus2Chungus2Chungus2Chungus2Chungus2Chungus2", "Chungus3"]
        
        cell.messageBody.text = messageArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
        
    }
    
    
    func configureTableView() {
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.estimatedRowHeight = 120
    }
    
    
}

//TODO: hide navigation bar when scrolling down
//TODO: make navigation bar black when it's here
