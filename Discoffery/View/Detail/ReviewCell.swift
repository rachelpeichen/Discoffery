//
//  ReviewCell.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/24.
//

import UIKit
import Cosmos

class ReviewCell: UITableViewCell {

  @IBOutlet weak var userImage: UIImageView!
  @IBOutlet weak var userName: UILabel!
  @IBOutlet weak var rateStars: CosmosView!
  @IBOutlet weak var postTIme: UILabel!
  @IBOutlet weak var recommendItem1: UILabel!
  @IBOutlet weak var recommendItem2: UILabel!
  @IBOutlet weak var comment: UILabel!


  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    userImage.layer.cornerRadius = 25
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
