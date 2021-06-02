//
//  AddItemCollectionViewCell.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/6/2.
//

import UIKit

protocol AddItemCollectionViewCellDelegate: AnyObject {

  func removeAddedItem(index: Int)
}

class AddItemCollectionViewCell: UICollectionViewCell {

  // MARK: - Properties
  weak var delegate: AddItemCollectionViewCellDelegate?

  // MARK: - Outlets
  @IBOutlet weak var addedItemLabel: PaddingLabel!

  @IBAction func onTapRemoveItemBtn(_ sender: UIButton) {

    delegate?.removeAddedItem( index: sender.tag)
  }

  @IBOutlet weak var removeItemBtn: UIButton!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  func layoutAddItemCollectionViewCell(from: String) {

    addedItemLabel.text = from
  }
}
