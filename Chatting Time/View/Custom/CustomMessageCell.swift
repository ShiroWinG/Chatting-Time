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

        avatarImageview.layer.borderWidth = 1
        avatarImageview.layer.masksToBounds = false
        avatarImageview.layer.borderColor = UIColor.clear.cgColor
        avatarImageview.layer.cornerRadius = avatarImageview.frame.height/2
        avatarImageview.clipsToBounds = true
    }
}
