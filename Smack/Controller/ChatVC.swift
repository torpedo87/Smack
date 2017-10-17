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
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var channelNameLabel: UILabel!
  @IBOutlet weak var sendBtn: UIButton!
  @IBOutlet weak var typingUsersLabel: UILabel!
  
  var isTyping = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
    sendBtn.isHidden = true
    
    //일반적인 tableviewcell의 높이
    tableView.estimatedRowHeight = 80
    //메시지가 여러줄일 경우 셀 크기 동적으로 조정됨
    tableView.rowHeight = UITableViewAutomaticDimension
    
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
    
    //실시간으로 메시지 받기
    SocketService.instance.getChatMessages { (newMessage) in
      if newMessage.channelId == MessageService.instance.selectedChannel?.id && AuthService.instance.isLoggedIn {
        MessageService.instance.messages.append(newMessage)
        self.tableView.reloadData()
        if MessageService.instance.messages.count > 0 {
          let lastIndex = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
          self.tableView.scrollToRow(at: lastIndex, at: .bottom, animated: false)
        }
      }
    }
    
    //실시간으로 타이핑 유저 확인하기
    SocketService.instance.getTypingUsers { (typingUsers) in
      guard let channelId = MessageService.instance.selectedChannel?.id else { return }
      
      var names = ""
      var numberOfTypers = 0
      
      for (userName, channelID) in typingUsers {
        if userName != UserDataService.instance.name && channelId == channelID {
          if names == "" {
            names = userName
          } else {
            names = "\(names), \(userName)"
          }
          numberOfTypers += 1
        }
      }
      
      if numberOfTypers > 0 && AuthService.instance.isLoggedIn {
        var verb = "is"
        if numberOfTypers > 1 {
          verb = "are"
        }
        self.typingUsersLabel.text = "\(names) \(verb) typing a message"
      } else {
        self.typingUsersLabel.text = ""
      }
    }
    
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
      tableView.reloadData()
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
        self.tableView.reloadData()
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
          SocketService.instance.socket.emit("stopType", UserDataService.instance.name)
        }
      })
    }
  }
  
  //텍스트가 있을 때에만 send 버튼 활성화
  @IBAction func messageTxtEditing(_ sender: Any) {
    guard let channelId = MessageService.instance.selectedChannel?.id else { return }
    if mesageTxt.text == "" {
      isTyping = false
      sendBtn.isHidden = true
      
      //api에게 타이핑 중 아니라고 알리기
      SocketService.instance.socket.emit("stopType", UserDataService.instance.name)
    } else {
      if isTyping == false {
        sendBtn.isHidden = false
        SocketService.instance.socket.emit("startType", UserDataService.instance.name, channelId)
      }
      isTyping = true
    }
  }
}

extension ChatVC: UITableViewDelegate {
  
}

extension ChatVC: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return MessageService.instance.messages.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageCell {
      let message = MessageService.instance.messages[indexPath.row]
      cell.configureCell(message: message)
      return cell
    } else {
      return MessageCell()
    }
  }
}
