//
//  ChatVC.swift
//  Smack
//
//  Created by junwoo on 2017. 10. 10..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {
  
  @IBOutlet weak var mesageTxt: UITextField!
  @IBOutlet weak var menuBtn: UIButton!
  
  @IBOutlet weak var channelNameLabel: UILabel!
  override func viewDidLoad() {
    super.viewDidLoad()
    //키보드 사용시 뷰도 올라가기
    view.bindToKeyboard()
    //화면 탭해서 키보드 내리기
    let tap = UITapGestureRecognizer(target: self, action: #selector(ChatVC.closeTap))
    view.addGestureRecognizer(tap)
    
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
  
  @objc func closeTap() {
    view.endEditing(true)
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
    getMessages()
  }
  
  func onLoginGetMessages() {
    MessageService.instance.findAllChannels { (success) in
      if success {
        if MessageService.instance.channels.count > 0 {
          MessageService.instance.selectedChannel = MessageService.instance.channels[0]
          self.updateWithChannel()
        } else {
          self.channelNameLabel.text = "no channels yet"
        }
      }
    }
  }
  
  func getMessages() {
    guard let channelId = MessageService.instance.selectedChannel?.id else { return }
    MessageService.instance.findAllMessagesForChannel(channelId: channelId) { (success) in
      if success {
        
      }
    }
  }
  @IBAction func sendMessageBtnPressed(_ sender: Any) {
    if AuthService.instance.isLoggedIn {
      guard let channelId = MessageService.instance.selectedChannel?.id else { return }
      guard let messageBody = mesageTxt.text else { return }
      
      SocketService.instance.addMessage(messageBody: messageBody, userId: UserDataService.instance.id, channelId: channelId, completion: { (success) in
        if success {
          self.mesageTxt.text = ""
          //키보드 내리기
          self.mesageTxt.resignFirstResponder()
        }
      })
    }
  }
  
}
