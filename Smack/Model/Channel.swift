//
//  Channel.swift
//  Smack
//
//  Created by junwoo on 2017. 10. 14..
//  Copyright © 2017년 samchon. All rights reserved.
//

import Foundation

//decodable을 적용하려면 서버로부터 받은 responde body의 모든 파라미터를 똑같은 이름으로 포함해야 한다

struct Channel: Decodable {
//  public private(set) var name: String!
//  public private(set) var description: String!
//  public private(set) var _id: String!
//  public private(set) var __v: Int?
  
  public private(set) var channelTitle: String!
  public private(set) var channelDescription: String!
  public private(set) var id: String!
}
