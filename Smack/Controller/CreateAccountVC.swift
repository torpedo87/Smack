//
//  CreateAccountVC.swift
//  Smack
//
//  Created by junwoo on 2017. 10. 10..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {
  
  @IBOutlet weak var usernameTxt: UITextField!
  @IBOutlet weak var emailTxt: UITextField!
  @IBOutlet weak var passwordTxt: UITextField!
  @IBOutlet weak var userImg: UIImageView!
  
  var avatarName = "profileDefault"
  var avatarColor = "[0.5, 0.5, 0.5, 1]"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if UserDataService.instance.avatarName != "" {
      userImg.image = UIImage(named: UserDataService.instance.avatarName)
      avatarName = UserDataService.instance.avatarName
    }
  }
  
  @IBAction func closeBtnPressed(_ sender: Any) {
    //dismiss(animated: true, completion: nil)
    
    //close 버튼탭시 segue가 다 풀어지고 channelVC로 돌아간다
    performSegue(withIdentifier: UNWIND, sender: nil)
  }
  
  @IBAction func chooseAvatarBtnPressed(_ sender: Any) {
    performSegue(withIdentifier: TO_AVATAR_PICKER, sender: nil)
  }
  
  @IBAction func generateBGcolorBtnPressed(_ sender: Any) {
  }
  
  @IBAction func createAccountBtnPressed(_ sender: Any) {
    guard let name = usernameTxt.text, usernameTxt.text != " " else { return }
    guard let email = emailTxt.text, emailTxt.text != " " else { return }
    guard let password = passwordTxt.text, passwordTxt.text != " " else { return }
    
    AuthService.instance.registerUser(email: email, password: password) { (success) in
      
      if success {
        AuthService.instance.loginUser(email: email, password: password, completion: { (success) in
          if success {
            print("login success token: ", AuthService.instance.authToken)
            AuthService.instance.createUser(name: name, email: email, avatarName: self.avatarName, avatarColor: self.avatarColor, completion: { (success) in
              if success {
                print("createUser success", UserDataService.instance.name, UserDataService.instance.avatarName)
                self.performSegue(withIdentifier: UNWIND, sender: nil)
              }
            })
          }
        })
      }
      
    }
  }
}
