//
//  BlockListTableViewCell.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/6/9.
//

import UIKit

class BlockListTableViewCell: UITableViewCell {

  @IBOutlet weak var blockedUserLabel: UILabel!

  @IBOutlet weak var unBlockUserBtn: PaddingLabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }

  func layoutBlockListCell(user: String) {

    blockedUserLabel.text = user
  }
}
