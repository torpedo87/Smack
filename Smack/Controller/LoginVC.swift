//
//  LoginVC.swift
//  Smack
//
//  Created by junwoo on 2017. 10. 10..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
  
  @IBOutlet weak var usernameTxt: UITextField!
  @IBOutlet weak var passwordTxt: UITextField!
  @IBOutlet weak var spinner: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
  }
  
  func setupView() {
    //placeholder text color
    spinner.isHidden = true
    usernameTxt.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedStringKey.foregroundColor:SmackPurplePlaceholer])
    
    passwordTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor:SmackPurplePlaceholer])
    
  }
  
  @IBAction func loginBtnPressed(_ sender: Any) {
    spinner.isHidden = false
    spinner.startAnimating()
    
    guard let email = usernameTxt.text, usernameTxt.text != " " else { return }
    guard let password = passwordTxt.text, passwordTxt.text != " " else { return }
    
    AuthService.instance.loginUser(email: email, password: password) { (success) in
      if success {
        AuthService.instance.findUserByEmail(completion: { (success) in
          if success {
            NotificationCenter.default.post(name: NOTI_USER_DATA_DID_CHANGE, object: nil)
            self.spinner.isHidden = true
            self.spinner.stopAnimating()
            self.dismiss(animated: true, completion: nil)
          }
        })
      }
    }
  }
  @IBAction func closeBtnPressed(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func createAccountBtnPressed(_ sender: Any) {
    performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: nil)
  }
}
