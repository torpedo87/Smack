//
//  CircleImage.swift
//  Smack
//
//  Created by junwoo on 2017. 10. 12..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit
@IBDesignable

class CircleImage: UIImageView {
  override func awakeFromNib() {
    super.awakeFromNib()
    setupView()
  }
  
  func setupView() {
    self.layer.cornerRadius = self.frame.width / 2
    self.clipsToBounds = true
  }
  
  override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    setupView()
  }
}
