//
//  ProtraitCardCollectionCell.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/17.
//

import UIKit
import Cosmos

class ProtraitCardCollectionCell: UICollectionViewCell {

  // MARK: Outlets
  @IBOutlet weak var image: UIImageView!
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var featureOne: UILabel!
  @IBOutlet weak var rateStars: CosmosView!
  @IBOutlet weak var featureTwo: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
}
