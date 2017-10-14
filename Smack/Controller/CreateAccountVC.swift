//
//  CreateAccountVC.swift
//  Smack
//
//  Created by junwoo on 2017. 10. 10..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {
  
  @IBOutlet weak var spinner: UIActivityIndicatorView!
  @IBOutlet weak var usernameTxt: UITextField!
  @IBOutlet weak var emailTxt: UITextField!
  @IBOutlet weak var passwordTxt: UITextField!
  @IBOutlet weak var userImg: UIImageView!
  
  var avatarName = "profileDefault"
  var avatarColor = "[0.5, 0.5, 0.5, 1]"
  var bgColor: UIColor?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    // Do any additional setup after loading the view.
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if UserDataService.instance.avatarName != "" {
      userImg.image = UIImage(named: UserDataService.instance.avatarName)
      avatarName = UserDataService.instance.avatarName
      
      if avatarName.contains("light") && bgColor == nil {
        userImg.backgroundColor = UIColor.lightGray
      }
    }
  }
  
  func setupView() {
    //placeholder text color
    spinner.isHidden = true
    usernameTxt.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedStringKey.foregroundColor:SmackPurplePlaceholer])
    
    emailTxt.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedStringKey.foregroundColor:SmackPurplePlaceholer])
    
    passwordTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor:SmackPurplePlaceholer])
    
    //키보드 탭
    let tap = UITapGestureRecognizer(target: self, action: #selector(CreateAccountVC.handleTap))
    view.addGestureRecognizer(tap)
  }
  
  @objc func handleTap() {
    view.endEditing(true)
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
    let r = CGFloat(arc4random_uniform(255)) / 255
    let g = CGFloat(arc4random_uniform(255)) / 255
    let b = CGFloat(arc4random_uniform(255)) / 255
    
    bgColor = UIColor(red: r, green: g, blue: b, alpha: 1)
    avatarColor = "[\(r), \(g), \(b), 1]"
    UIView.animate(withDuration: 0.2) {
      self.userImg.backgroundColor = self.bgColor
    }
    
  }
  
  @IBAction func createAccountBtnPressed(_ sender: Any) {
    spinner.isHidden = false
    spinner.startAnimating()
    
    guard let name = usernameTxt.text, usernameTxt.text != "" else { return }
    guard let email = emailTxt.text, emailTxt.text != "" else { return }
    guard let password = passwordTxt.text, passwordTxt.text != "" else { return }
    
    AuthService.instance.registerUser(email: email, password: password) { (success) in
      
      if success {
        AuthService.instance.loginUser(email: email, password: password, completion: { (success) in
          if success {
            print("login success token: ", AuthService.instance.authToken)
            AuthService.instance.createUser(name: name, email: email, avatarName: self.avatarName, avatarColor: self.avatarColor, completion: { (success) in
              if success {
                print("createUser success", UserDataService.instance.name, UserDataService.instance.avatarName)
                self.spinner.isHidden = true
                self.spinner.stopAnimating()
                self.performSegue(withIdentifier: UNWIND, sender: nil)
                NotificationCenter.default.post(name: NOTI_USER_DATA_DID_CHANGE, object: nil)
              }
            })
          }
        })
      }
      
    }
  }
}
