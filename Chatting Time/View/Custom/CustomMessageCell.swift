//
//  CustomMessageCell.swift
//  Chatting Time
//
//  Created by Zhi Wei Zhang on 5/4/19.
//  Copyright © 2019 Zhi Wei Zhang. All rights reserved.
//

import UIKit

class CustomMessageCell: UITableViewCell {
    
    @IBOutlet var messageBackground: UIView!
    @IBOutlet var avatarImageview: UIImageView!
    @IBOutlet var senderUsername: UILabel!
    @IBOutlet var messageBody: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
