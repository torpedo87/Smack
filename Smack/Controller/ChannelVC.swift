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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //토글너비 조정
    self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
  }
  
  
  @IBAction func loginBtnPressed(_ sender: Any) {
    performSegue(withIdentifier: TO_LOGIN, sender: nil)
  }
  
}
