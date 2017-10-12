//
//  AvatarCell.swift
//  Smack
//
//  Created by junwoo on 2017. 10. 12..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

class AvatarCell: UICollectionViewCell {

  @IBOutlet weak var avatarImg: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupView()
  }
  
  func setupView() {
    self.layer.backgroundColor = UIColor.lightGray.cgColor
    self.layer.cornerRadius = 10
    
    //이미지가 셀 밖으로 안 삐져나가도록
    self.clipsToBounds = true
  }
}
