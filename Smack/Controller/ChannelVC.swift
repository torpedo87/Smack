//
//  ChannelVC.swift
//  Smack
//
//  Created by junwoo on 2017. 10. 10..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var loginBtn: UIButton!
  @IBOutlet weak var userImg: CircleImage!
  @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {}
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    
    //토글너비 조정
    self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
    
    //observer를 사용하여 noti 를 받기
    NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChange(_:)), name: NOTI_USER_DATA_DID_CHANGE, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.channelsLoaded(_:)), name: NOTI_CHANNELS_LOADED, object: nil)
    
    //api로부터 채널 생성됐다고 알림받기
    SocketService.instance.getChannel { (success) in
      if success {
        self.tableView.reloadData()
      }
    }
    
    //다른 채널의 새 메시지 알림받기
    SocketService.instance.getChatMessages { (newMessage) in
      if MessageService.instance.selectedChannel?.id != newMessage.channelId && AuthService.instance.isLoggedIn {
        MessageService.instance.unreadChannels.append(newMessage.channelId)
        self.tableView.reloadData()
      }
    }
  }
  
  //앱재실행시 로그인여부 확인
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setUserInfo()
    
  }
  
  @objc func userDataDidChange(_ noti: Notification) {
    setUserInfo()
  }
  
  @objc func channelsLoaded(_ noti: Notification) {
    tableView.reloadData()
  }
  
  func setUserInfo() {
    if AuthService.instance.isLoggedIn {
      loginBtn.setTitle(UserDataService.instance.name, for: .normal)
      userImg.image = UIImage(named: UserDataService.instance.avatarName)
      userImg.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
    } else {
      loginBtn.setTitle("Login", for: .normal)
      userImg.image = UIImage(named: "menuProfileIcon")
      userImg.backgroundColor = UIColor.clear
      tableView.reloadData()
    }
  }
  
  
  @IBAction func loginBtnPressed(_ sender: Any) {
    if AuthService.instance.isLoggedIn {
      let profileVC = ProfileVC()
      profileVC.modalPresentationStyle = .custom
      present(profileVC, animated: true, completion: nil)
      
    } else {
      performSegue(withIdentifier: TO_LOGIN, sender: nil)
    }
    
  }
  
  @IBAction func addChannelBtnPressed(_ sender: Any) {
    if AuthService.instance.isLoggedIn {
      let addChannelVC = AddChannelVC()
      addChannelVC.modalPresentationStyle = .custom
      present(addChannelVC, animated: true, completion: nil)
    }
    
  }
}

extension ChannelVC: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let channel = MessageService.instance.channels[indexPath.row]
    MessageService.instance.selectedChannel = channel
    NotificationCenter.default.post(name: NOTI_CHANNEL_SELECTED, object: nil)
    
    self.revealViewController().revealToggle(animated: true)
    
    if MessageService.instance.unreadChannels.count > 0 {
      MessageService.instance.unreadChannels = MessageService.instance.unreadChannels.filter{ $0 != channel.id }
    }
    let index = IndexPath(row: indexPath.row, section: 0)
    tableView.reloadRows(at: [index], with: .none)
    tableView.selectRow(at: index, animated: false, scrollPosition: .none)
  }
}

extension ChannelVC: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath) as? ChannelCell {
      
      let channel = MessageService.instance.channels[indexPath.row]
      cell.configureCell(channel: channel)
      return cell
    } else {
      return UITableViewCell()
    }
    
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return MessageService.instance.channels.count
  }
}
