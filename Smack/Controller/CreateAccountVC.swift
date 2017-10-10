//
//  CreateAccountVC.swift
//  Smack
//
//  Created by junwoo on 2017. 10. 10..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  @IBAction func closeBtnPressed(_ sender: Any) {
    //dismiss(animated: true, completion: nil)
    
    //close 버튼탭시 segue가 다 풀어지고 channelVC로 돌아간다
    performSegue(withIdentifier: UNWIND, sender: nil)
  }
}
