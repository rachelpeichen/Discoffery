//
//  ReviewCell.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/24.
//

import UIKit
import Cosmos

class ReviewCell: UITableViewCell {

  // MARK: - Properties
  var recommendItems: [String] = [] {

    didSet {
      layoutItemLabels()
    }
  }

  // MARK: - Outlets
  @IBOutlet weak var userImage: UIImageView!

  @IBOutlet weak var userName: UILabel!

  @IBOutlet weak var rateStars: CosmosView!

  @IBOutlet weak var postTime: UILabel!

  @IBOutlet weak var comment: UILabel!

  @IBOutlet weak var itemOne: PaddingLabel!

  @IBOutlet weak var itemTwo: PaddingLabel!

  @IBOutlet weak var itemThree: PaddingLabel!

  @IBOutlet weak var noItemLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code

    userImage.layer.cornerRadius = 25

    layoutItemLabels()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

  func layoutItemLabels() {

    switch recommendItems.count {

    case 0:

      noItemLabel.isHidden = false

      itemOne.isHidden = true

      itemTwo.isHidden = true

      itemThree.isHidden = true

    case 1:

      noItemLabel.isHidden = true

      itemOne.isHidden = false

      itemOne.text = recommendItems[0]

      itemTwo.isHidden = true

      itemThree.isHidden = true

    case 2:

      noItemLabel.isHidden = true

      itemOne.isHidden = false

      itemOne.text = recommendItems[0]

      itemTwo.isHidden = false

      itemTwo.text = recommendItems[1]

      itemThree.isHidden = true

    case 3:

      noItemLabel.isHidden = true

      itemOne.isHidden = false

      itemOne.text = recommendItems[0]

      itemTwo.isHidden = false

      itemTwo.text = recommendItems[1]

      itemThree.isHidden = false

      itemThree.text = recommendItems[2]

    default:

      noItemLabel.isHidden = true

      itemOne.isHidden = false

      itemOne.text = recommendItems[0]

      itemTwo.isHidden = false

      itemTwo.text = recommendItems[1]

      itemThree.isHidden = false

      itemThree.text = recommendItems[2]

    }

  }

}
