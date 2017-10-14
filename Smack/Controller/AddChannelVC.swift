//
//  AddChannelVC.swift
//  Smack
//
//  Created by junwoo on 2017. 10. 14..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

class AddChannelVC: UIViewController {
  
  @IBOutlet weak var bgView: UIView!
  @IBOutlet weak var descriptionTxt: UITextField!
  @IBOutlet weak var nameTxt: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
  }
  
  func setupView() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(AddChannelVC.closeTap(_:)))
    bgView.addGestureRecognizer(tap)
    
    nameTxt.attributedPlaceholder = NSAttributedString(string: "channelName", attributes: [NSAttributedStringKey.foregroundColor:SmackPurplePlaceholer])
    descriptionTxt.attributedPlaceholder = NSAttributedString(string: "description", attributes: [NSAttributedStringKey.foregroundColor:SmackPurplePlaceholer])
  }
  
  @objc func closeTap(_ recongnizer: UITapGestureRecognizer) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func closeModalBtnPressed(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  @IBAction func createChannelBtnPressed(_ sender: Any) {
    guard let channelName = nameTxt.text, nameTxt.text != "" else { return }
    guard let channelDescription = descriptionTxt.text else { return }
    SocketService.instance.addChannel(channelName: channelName, channelDescription: channelDescription) { (success) in
      if success {
        self.dismiss(animated: true, completion: nil)
      }
    }
  }
  
}
