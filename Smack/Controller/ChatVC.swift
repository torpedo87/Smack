//
//  ChatVC.swift
//  Smack
//
//  Created by junwoo on 2017. 10. 10..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {
  
  @IBOutlet weak var menuBtn: UIButton!
  
  @IBOutlet weak var channelNameLabel: UILabel!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
    
    //드래그
    self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    //탭해서 닫기
    self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    
    NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_:)), name: NOTI_USER_DATA_DID_CHANGE, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected(_:)), name: NOTI_CHANNEL_SELECTED, object: nil)
    
    if AuthService.instance.isLoggedIn {
      AuthService.instance.findUserByEmail(completion: { (success) in
        if success {
          NotificationCenter.default.post(name: NOTI_USER_DATA_DID_CHANGE, object: nil)
        }
      })
    }
    
  }
  
  @objc func userDataDidChange(_ noti: Notification) {
    if AuthService.instance.isLoggedIn {
      onLoginGetMessages()
    } else {
      channelNameLabel.text = "Please login"
    }
  }
  
  @objc func channelSelected(_ noti: Notification) {
    updateWithChannel()
  }
  
  func updateWithChannel() {
    let channelName = MessageService.instance.selectedChannel?.channelTitle ?? ""
    channelNameLabel.text = "#\(channelName)"
    
  }
  
  func onLoginGetMessages() {
    MessageService.instance.findAllChannels { (success) in
      if success {
        
      }
    }
  }
  
}
