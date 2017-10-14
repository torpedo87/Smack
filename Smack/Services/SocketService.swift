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
  
  //api 에 전송
  func addChannel(channelName: String, channelDescription: String, completion: @escaping CompletionHandler) {
    socket.emit("newChannel", channelName, channelDescription)
    completion(true)
  }
  
  //api로부터 받기(이 앱과 연결된 모든 사용자에게 동시에 반영)
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
}
