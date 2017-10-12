//
//  UserDataService.swift
//  Smack
//
//  Created by junwoo on 2017. 10. 12..
//  Copyright © 2017년 samchon. All rights reserved.
//

import Foundation

class UserDataService {
  
  static let instance = UserDataService()
  
  //public get, private set
  public private(set) var id = ""
  public private(set) var avatarColor = ""
  public private(set) var avatarName = ""
  public private(set) var email = ""
  public private(set) var name = ""
  
  //setter
  func setUserData(id: String, avatarColor: String, avatarName: String, email: String, name: String) {
    self.id = id
    self.avatarColor = avatarColor
    self.avatarName = avatarName
    self.email = email
    self.name = name
  }
  
  func setAvatarName(avatarName: String) {
    self.avatarName = avatarName
  }
}
