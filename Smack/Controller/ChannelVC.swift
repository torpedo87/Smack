//
//  ChannelVC.swift
//  Smack
//
//  Created by junwoo on 2017. 10. 10..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {
  
  @IBOutlet weak var loginBtn: UIButton!
  @IBOutlet weak var userImg: CircleImage!
  @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {}
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //토글너비 조정
    self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
    
    //observer를 사용하여 noti 를 받기
    NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChange(_:)), name: NOTI_USER_DATA_DID_CHANGE, object: nil)
  }
  
  //앱재실행시 로그인여부 확인
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setUserInfo()
    
  }
  
  @objc func userDataDidChange(_ noti: Notification) {
    setUserInfo()
  }
  
  func setUserInfo() {
    if AuthService.instance.isLoggedIn {
      loginBtn.setTitle(UserDataService.instance.name, for: .normal)
      userImg.image = UIImage(named: UserDataService.instance.avatarName)
      userImg.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
    } else {
      loginBtn.setTitle("Login", for: .normal)
      userImg.image = UIImage(named: "menuProfileIcon")
      userImg.backgroundColor = UIColor.clear
    }
  }
  
  
  @IBAction func loginBtnPressed(_ sender: Any) {
    if AuthService.instance.isLoggedIn {
      let profileVC = ProfileVC()
      profileVC.modalPresentationStyle = .custom
      present(profileVC, animated: true, completion: nil)
      
    } else {
      performSegue(withIdentifier: TO_LOGIN, sender: nil)
    }
    
  }
  
}
