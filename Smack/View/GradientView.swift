//
//  GradientView.swift
//  Smack
//
//  Created by junwoo on 2017. 10. 10..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

//스토리보드 미리보기
@IBDesignable

class GradientView: UIView {
  
  //스토리보드에서 동적으로 변화 확인
  @IBInspectable var topColor: UIColor = UIColor.blue {
    didSet {
      //setNeedsLayout 이 layoutSubviews 를 invoke
      self.setNeedsLayout()
    }
  }
  
  @IBInspectable var bottomColor: UIColor = UIColor.green {
    didSet {
      self.setNeedsLayout()
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
    
    gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
    gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
    gradientLayer.frame = self.bounds
    
    self.layer.insertSublayer(gradientLayer, at: 0)
    
  }
}
