//
//  AvatarPickerVC.swift
//  Smack
//
//  Created by junwoo on 2017. 10. 12..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit

class AvatarPickerVC: UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var segmentControl: UISegmentedControl!
  
  var avatarType = AvatarType.dark
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.delegate = self
    collectionView.dataSource = self
  }
  
  @IBAction func backBtnPressed(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  @IBAction func segmentControlChanged(_ sender: Any) {
    if segmentControl.selectedSegmentIndex == 0 {
      avatarType = .dark
    } else {
      avatarType = .light
    }
    collectionView.reloadData()
  }
  
}

extension AvatarPickerVC: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if avatarType == .dark {
      UserDataService.instance.setAvatarName(avatarName: "dark\(indexPath.item)")
    } else {
      UserDataService.instance.setAvatarName(avatarName: "light\(indexPath.item)")
    }
    self.dismiss(animated: true, completion: nil)
  }
}

extension AvatarPickerVC: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "avatarCell", for: indexPath) as? AvatarCell {
      cell.configureCell(index: indexPath.item, type: avatarType)
      return cell
    }
    return AvatarCell()
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 28
  }
  
}

extension AvatarPickerVC: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    //iphone SE
    var numberOfColumns: CGFloat = 3
    
    //iphone 6 이상
    if UIScreen.main.bounds.width > 320 {
      numberOfColumns = 4
    }
    //셀간의 간격
    let spaceBetweenCells: CGFloat = 10
    
    //화면의 양옆 패딩
    let padding: CGFloat = 40
    
    //각 셀의 가로길이
    let cellDimension = ((UIScreen.main.bounds.width - padding - (numberOfColumns - 1) * spaceBetweenCells)) / numberOfColumns
    
    return CGSize(width: cellDimension, height: cellDimension)
  }
}
