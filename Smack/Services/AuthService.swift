//
//  AuthService.swift
//  Smack
//
//  Created by junwoo on 2017. 10. 11..
//  Copyright © 2017년 samchon. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AuthService {
  
  //싱글톤
  static let instance = AuthService()
  
  let defaults = UserDefaults.standard
  
  var isLoggedIn: Bool {
    get {
      return defaults.bool(forKey: LOGGED_IN_KEY)
    }
    
    set {
      defaults.set(newValue, forKey: LOGGED_IN_KEY)
    }
  }
  
  var authToken: String {
    get {
      return defaults.value(forKey: TOKEN_KEY) as! String
    }
    
    set {
      defaults.set(newValue, forKey: TOKEN_KEY)
    }
  }
  
  var userEmail: String {
    get {
      return defaults.value(forKey: USER_EMAIL) as! String
    }
    
    set {
      defaults.set(newValue, forKey: USER_EMAIL)
    }
  }
  
  //이메일, 비번으로 회원가입
  func registerUser(email: String, password: String, completion: @escaping CompletionHandler) {
    
    let lowerCaseEmail = email.lowercased()
    
    let body: [String:Any] = [
      "email": lowerCaseEmail,
      "password": password
    ]
    
    Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseString { (response) in
      
      if response.result.error == nil {
        completion(true)
      } else {
        completion(false)
        debugPrint(response.result.error as Any)
      }
    }
    
  }
  
  //이메일, 비번으로 로그인
  func loginUser(email: String, password: String, completion: @escaping CompletionHandler) {
    let lowerCaseEmail = email.lowercased()
    
    let body: [String:Any] = [
      "email": lowerCaseEmail,
      "password": password
    ]
    
    Alamofire.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
      
      if response.result.error == nil {
        
        //swiftyjson 사용안할 때 dict 형태로 캐스팅하여 하나씩 unwrapping 해야한다
//        if let json = response.result.value as? Dictionary<String, Any> {
//          if let email = json["user"] as? String {
//            self.userEmail = email
//          }
//          if let token = json["token"] as? String {
//            self.authToken = token
//          }
//        }
        
        //swiftyjson 사용
        guard let data = response.data else { return }
        let json = JSON(data: data)
        self.userEmail = json["user"].stringValue
        self.authToken = json["token"].stringValue
        
        self.isLoggedIn = true
        completion(true)
        
      } else {
        completion(false)
        debugPrint(response.result.error as Any)
      }
    }
  }
  
  //아바타 생성
  func createUser(name: String, email: String, avatarName: String, avatarColor: String, completion: @escaping CompletionHandler) {
    let lowerCaseEmail = email.lowercased()
    
    let body: [String:Any] = [
      "email": lowerCaseEmail,
      "name": name,
      "avatarName": avatarName,
      "avatarColor": avatarColor
    ]
    
    Alamofire.request(URL_USER_ADD, method: .post, parameters: body, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
      if response.result.error == nil {
        guard let data = response.data else { return }
        self.setUserInfo(data: data)
        
        completion(true)
      } else {
        completion(false)
        debugPrint(response.result.error as Any)
      }
    }
    
  }
  
  func findUserByEmail(completion: @escaping CompletionHandler) {
    Alamofire.request("\(URL_USER_BY_EMAIL)\(userEmail)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
      
      if response.result.error == nil {
        guard let data = response.data else { return }
        self.setUserInfo(data: data)
        
        completion(true)
      } else {
        completion(false)
        debugPrint(response.result.error as Any)
      }
      
    }
  }
  
  func setUserInfo(data: Data) {
    
    let json = JSON(data: data)
    let id = json["_id"].stringValue
    let name = json["name"].stringValue
    let email = json["email"].stringValue
    let avatarColor = json["avatarColor"].stringValue
    let avatarName = json["avatarName"].stringValue
    
    UserDataService.instance.setUserData(id: id, avatarColor: avatarColor, avatarName: avatarName, email: email, name: name)
  }
}
