//
//  WriteReviewCell.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/17.
//

import UIKit
import Cosmos
import JGProgressHUD

class WriteReviewCell: ShopDetailBasicCell {

  @IBOutlet weak var uploadPhotosButton: UIButton!

  @IBOutlet weak var addRecommednItemButton: UIButton!
  
  @IBOutlet weak var rateStars: CosmosView!

  // MARK: 先做拿到評價 評分 一個推薦品
  @IBOutlet weak var reviewComment: UITextField!

  @IBOutlet weak var recommendItemTextField: UITextField!

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
