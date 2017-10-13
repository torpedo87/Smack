//
//  ProfileVC.swift
//  Smack
//
//  Created by junwoo on 2017. 10. 13..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
  
  @IBOutlet weak var bgView: UIView!
  @IBOutlet weak var userEmailLabel: UILabel!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var profileImg: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  func setupView() {
    userNameLabel.text = UserDataService.instance.name
    userEmailLabel.text = UserDataService.instance.email
    profileImg.image = UIImage(named: UserDataService.instance.avatarName)
    profileImg.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(ProfileVC.closeTap(_:)))
    bgView.addGestureRecognizer(tap)
  }
  
  @objc func closeTap(_ recognizer: UITapGestureRecognizer) {
    dismiss(animated: true, completion: nil)
  }

  @IBAction func logoutBtnPressed(_ sender: Any) {
    UserDataService.instance.logoutUser()
    NotificationCenter.default.post(name: NOTI_USER_DATA_DID_CHANGE, object: nil)
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func closeModalBtnPressed(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
}
