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
        }
        
        //struct channel 이 decodable 인 경우
//        do {
//          self.channels = try JSONDecoder().decode([Channel].self, from: data)
//        } catch let error {
//          debugPrint(error as Any)
//        }
        
        NotificationCenter.default.post(name: NOTI_CHANNELS_LOADED, object: nil)
        completion(true)
      } else {
        completion(false)
        debugPrint(response.result.error as Any)
      }
    }
  }
  
  func clearChannels() {
    channels.removeAll()
  }
}
