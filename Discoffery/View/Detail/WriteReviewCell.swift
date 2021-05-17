//
//  WriteReviewCell.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/17.
//

import UIKit
import Cosmos

class WriteReviewCell: ShopDetailBasicCell {

  @IBOutlet weak var rateStars: CosmosView!

  @IBOutlet weak var uploadPhotosButton: UIButton!

  @IBOutlet weak var reviewComment: UITextField!

  @IBOutlet weak var recommendItemTextField: UITextField!

  @IBOutlet weak var addRecommednItemButton: UIButton!

  @IBOutlet weak var sendReviewButton: UIButton!

  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
