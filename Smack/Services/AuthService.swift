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
  
}
