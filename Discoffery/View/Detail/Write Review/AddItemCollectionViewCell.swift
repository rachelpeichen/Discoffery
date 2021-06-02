//
//  AddItemCollectionViewCell.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/6/2.
//

import UIKit


class AddItemCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var addedItemLabel: PaddingLabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  func layoutAddItemCollectionViewCell(from: String) {

    addedItemLabel.text = from
  }
}
