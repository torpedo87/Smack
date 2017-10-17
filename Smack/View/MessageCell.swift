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
    
    guard var isoDate = message.timestamp else { return }
    //뒤에서 5자리 제거
    let end = isoDate.index(isoDate.endIndex, offsetBy: -5)
    isoDate = isoDate.substring(to: end)
    
    //String -> isoDate
    let isoFormatter = ISO8601DateFormatter()
    let chatDate = isoFormatter.date(from: isoDate.appending("z"))
    
    //isoDate -> Date
    let newFormatter = DateFormatter()
    newFormatter.dateFormat = "MMM d, h:mm a"
    if let finalDate = chatDate {
      let finalDate = newFormatter.string(from: finalDate)
      timestampLabel.text = finalDate
    }
  }
  
}
