//
//  ChatVC.swift
//  Smack
//
//  Created by junwoo on 2017. 10. 10..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {
  
  @IBOutlet weak var menuBtn: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
    
    //드래그
    self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    //탭해서 닫기
    self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    
    if AuthService.instance.isLoggedIn {
      AuthService.instance.findUserByEmail(completion: { (success) in
        if success {
          NotificationCenter.default.post(name: NOTI_USER_DATA_DID_CHANGE, object: nil)
        }
      })
    }
    
    MessageService.instance.findAllChannels { (success) in
      
    }
  }
  
}
