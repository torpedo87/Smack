//
//  RoundedButton.swift
//  Smack
//
//  Created by junwoo on 2017. 10. 11..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

//스토리보드에 동적으로 반영
@IBDesignable

class RoundedButton: UIButton {
  
  //변화 감지할 대상
  @IBInspectable var cornerRadius: CGFloat = 5.0 {
    
    //바뀌었을 때 호출
    didSet {
      self.layer.cornerRadius = cornerRadius
    }
  }
  
  override func awakeFromNib() {
    self.setupView()
  }
  
  override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    self.setupView()
  }
  
  func setupView() {
    self.layer.cornerRadius = cornerRadius
  }
}
