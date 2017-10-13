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
  
  func returnUIColor(components: String) -> UIColor {
    // "[r, g, b]" 형태에서 r, g, b 추출하기
    let scanner = Scanner(string: components)
    let skipped = CharacterSet(charactersIn: "[], ")
    let comma = CharacterSet(charactersIn: ",")
    scanner.charactersToBeSkipped = skipped
    
    //스캔해서 변수에 담기
    var r, g, b, a: NSString?
    scanner.scanUpToCharacters(from: comma, into: &r)
    scanner.scanUpToCharacters(from: comma, into: &g)
    scanner.scanUpToCharacters(from: comma, into: &b)
    scanner.scanUpToCharacters(from: comma, into: &a)
    
    let defaultColor = UIColor.lightGray
    guard let rUnWrapped = r else { return defaultColor }
    guard let gUnWrapped = g else { return defaultColor }
    guard let bUnWrapped = b else { return defaultColor }
    guard let aUnWrapped = a else { return defaultColor }
    
    //NSString -> Double -> CGFloat
    let rFloat = CGFloat(rUnWrapped.doubleValue)
    let gFloat = CGFloat(gUnWrapped.doubleValue)
    let bFloat = CGFloat(bUnWrapped.doubleValue)
    let aFloat = CGFloat(aUnWrapped.doubleValue)
    
    return UIColor(red: rFloat, green: gFloat, blue: bFloat, alpha: aFloat)
  }
}
