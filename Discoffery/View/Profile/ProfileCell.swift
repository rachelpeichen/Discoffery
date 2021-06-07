//
//  ProfileCell.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/17.
//

import UIKit

class ProfileCell: UITableViewCell {

  @IBOutlet weak var settingButton: UIButton!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
    settingButton.layoutViewWithShadow()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }
}
