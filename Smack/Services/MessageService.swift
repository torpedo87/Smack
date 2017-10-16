//
//  MessageService.swift
//  Smack
//
//  Created by junwoo on 2017. 10. 14..
//  Copyright © 2017년 samchon. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageService {
  static let instance = MessageService()
  
  var channels = [Channel]()
  var selectedChannel: Channel?
  var messages = [Message]()
  
  func findAllChannels(completion: @escaping CompletionHandler) {
    Alamofire.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
      
      if response.result.error == nil {
        guard let data = response.data else { return }
        
        //struct channel 이 decodable 이 아닌 경우
        if let json = JSON(data: data).array {
          for channelItem in json {
            let channelName = channelItem["name"].stringValue
            let channelDescription = channelItem["description"].stringValue
            let channelId = channelItem["_id"].stringValue

            let channel = Channel(channelTitle: channelName, channelDescription: channelDescription, id: channelId)
            self.channels.append(channel)
          }
          
          NotificationCenter.default.post(name: NOTI_CHANNELS_LOADED, object: nil)
          completion(true)
        }
        
        //struct channel 이 decodable 인 경우
//        do {
//          self.channels = try JSONDecoder().decode([Channel].self, from: data)
//        } catch let error {
//          debugPrint(error as Any)
//        }
        
      } else {
        completion(false)
        debugPrint(response.result.error as Any)
      }
    }
  }
  
  func clearChannels() {
    channels.removeAll()
  }
  
  func clearMessages() {
    messages.removeAll()
  }
  
  func findAllMessagesForChannel(channelId: String, completion: @escaping CompletionHandler) {
    Alamofire.request("\(URL_GET_MESSAGES)\(channelId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
      if response.result.error == nil {
        self.clearMessages()
        guard let data = response.data else { return }
        if let json = JSON(data: data).array {
          for messageItem in json {
            let mesasgeBody = messageItem["messageBody"].stringValue
            let channelId = messageItem["channelId"].stringValue
            let id = messageItem["_id"].stringValue
            let userName = messageItem["userName"].stringValue
            let userAvatar = messageItem["userAvatar"].stringValue
            let userAvatarColor = messageItem["userAvatarColor"].stringValue
            let timeStamp = messageItem["timeStamp"].stringValue
            
            let message = Message(message: mesasgeBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timestamp: timeStamp)
            self.messages.append(message)
            
          }
          print("mesages: ",self.messages)
          completion(true)
        }
      } else {
        completion(false)
        debugPrint(response.result.error as Any)
      }
      
    }
  }
}
