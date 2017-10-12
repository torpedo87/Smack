//
//  Constants.swift
//  Smack
//
//  Created by junwoo on 2017. 10. 10..
//  Copyright © 2017년 samchon. All rights reserved.
//

import Foundation

typealias CompletionHandler = (_ Success: Bool) -> ()

//segue
let TO_LOGIN = "toLogin"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let UNWIND = "unwindToChannel"
let TO_AVATAR_PICKER = "toAvatarPicker"

//user defaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"

//url
let BASE_URL = "https://samchonchat.herokuapp.com/v1/"
let URL_REGISTER = "\(BASE_URL)account/register"
let URL_LOGIN = "\(BASE_URL)account/login"
let URL_USER_ADD = "\(BASE_URL)user/add"

//header
let HEADER = [
  "Content-Type": "application/json; charset=utf-8"
]

//color
let SmackPurplePlaceholer = #colorLiteral(red: 0.3254901961, green: 0.4215201139, blue: 0.7752227187, alpha: 0.5)

//notification
let NOTI_USER_DATA_DID_CHANGE = Notification.Name("notiUserDataChanged")
