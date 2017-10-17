//
//  SocketService.swift
//  Smack
//
//  Created by junwoo on 2017. 10. 14..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject {
  static let instance = SocketService()
  
  //nsobject 이므로 생성자 필요
  override init() {
    super.init()
  }
  
  var socket: SocketIOClient = SocketIOClient(socketURL: URL(string: BASE_URL)!)
  
  func establishConnection() {
    socket.connect()
  }
  
  func closeConnection() {
    socket.disconnect()
  }
  
  //채널을 만들어달라고 api 에게 전송
  func addChannel(channelName: String, channelDescription: String, completion: @escaping CompletionHandler) {
    socket.emit("newChannel", channelName, channelDescription)
    completion(true)
  }
  
  //api로부터 새로운 채널이 완성됐다는 것을 받기(이 앱과 연결된 모든 사용자에게 동시에 반영)
  func getChannel(completion: @escaping CompletionHandler) {
    socket.on("channelCreated") { (dataArray, ack) in
      guard let channelName = dataArray[0] as? String else { return }
      guard let channelDescription = dataArray[1] as? String else { return }
      guard let channelId = dataArray[2] as? String else { return }
      
      let newChannel = Channel(channelTitle: channelName, channelDescription: channelDescription, id: channelId)
      MessageService.instance.channels.append(newChannel)
      completion(true)
    }
  }
  
  func addMessage(messageBody: String, userId: String, channelId: String, completion: @escaping CompletionHandler) {
    let user = UserDataService.instance
    
    //메시지 만들어달라고 정보를 api 에 전송
    socket.emit("newMessage", messageBody, userId, channelId, user.name, user.avatarName, user.avatarColor)
    completion(true)
  }
  
  func getChatMessages(completion: @escaping (_ newMessage: Message) -> Void) {
    //api가 메시지를 만들었다고 관련 사용자들에게 알려줌
    socket.on("messageCreated") { (dataArray, ack) in
      guard let messageBody = dataArray[0] as? String else { return }
      guard let channelId = dataArray[2] as? String else { return }
      guard let userName = dataArray[3] as? String else { return }
      guard let userAvatar = dataArray[4] as? String else { return }
      guard let userAvatarColor = dataArray[5] as? String else { return }
      guard let id = dataArray[6] as? String else { return }
      guard let timeStamp = dataArray[7] as? String else { return }
      
      let newMessage = Message(message: messageBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timestamp: timeStamp)
      
      completion(newMessage)
      
    }
  }
  
  //api로부터 타이핑중인 유저 정보 받기
  func getTypingUsers(_ completion: @escaping (_ typingUsers:[String:String]) -> Void) {
    
    socket.on("userTypingUpdate") { (dataArray, ack) in
      guard let typingUsers = dataArray[0] as? [String:String] else { return }
      completion(typingUsers)
    }
  }
}
