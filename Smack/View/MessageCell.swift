//
//  MessageCell.swift
//  Smack
//
//  Created by junwoo on 2017. 10. 16..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
  
  @IBOutlet weak var userImg: CircleImage!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var timestampLabel: UILabel!
  @IBOutlet weak var messageLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  func configureCell(message: Message) {
    messageLabel.text = message.message
    usernameLabel.text = message.userName
    userImg.image = UIImage(named: message.userAvatar)
    userImg.backgroundColor = UserDataService.instance.returnUIColor(components: message.userAvatarColor)
  }
  
}
