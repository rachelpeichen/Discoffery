//
//  WriteReviewCell.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/17.
//

import UIKit
import Cosmos

protocol WriteReviewCellDelegate: AnyObject {

  func sendReview(inputReview: inout Review)

  func sendRecommendItem(inputItem: inout RecommendItem)
}

class WriteReviewCell: ShopDetailBasicCell {

  // MARK: - Properties
  weak var delegate: WriteReviewCellDelegate?

  var wrappedReview = Review()

  var wrappedRecommendItem = RecommendItem()

  var inputComment: String?

  var inputItem: [String] = []

  var inputRating: Double?

  // MARK: - Outlets
  @IBOutlet weak var reviewComment: UITextField!

  @IBOutlet weak var recommendItem: UITextField!

  @IBOutlet weak var rateStars: CosmosView! {

    didSet {

      rateStars.didFinishTouchingCosmos = { rating in

        self.inputRating = rating

        self.sendReviewButton.isEnabled = true

        self.sendReviewButton.tintColor = .green
      }
    }
  }

  // MARK: 拍照按鈕還沒弄
  @IBOutlet weak var uploadPhotosButton: UIButton!

  // 只先給輸入一個 其他用按鈕寫死ㄉ按鈕也還沒弄
  @IBOutlet weak var addRecommednItemButton: UIButton!

  @IBOutlet weak var sendReviewButton: UIButton!

  // MARK: - Outlets' Action
  @IBAction func didEndEditingComment(_ sender: UITextField) {

    inputComment = sender.text
  }

  @IBAction func didEndEditingItem(_ sender: UITextField) {

    inputItem.append(sender.text ?? "none")
  }

  @IBAction func finishEditingReview(_ sender: UIButton!) {

    // The user can send review only when rating is provided
    guard let inputRating = inputRating else { return }

    wrappedReview.rating = inputRating

    wrappedReview.comment = inputComment ?? "User didn't write comment."

    wrappedReview.recommendItems = inputItem ?? [""]

    delegate?.sendReview(inputReview: &wrappedReview)

    // If the user did provide recommend item then we can publish
    if !inputItem.isEmpty {

      for (index, item) in inputItem.enumerated() {

         print("index = \(index) & item = \(item)")

        wrappedRecommendItem.item = item

        // wrappedRecommendItem.count += 1 在這+1會導致count沒更新一直累加送到火地所以在DetailVC檢查：這樣的邏輯變成是這個人推薦了幾個項目count就會是多少！

        delegate?.sendRecommendItem(inputItem: &wrappedRecommendItem)
      }
      inputItem.removeAll()
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()

    // Initialization code
    sendReviewButton.isEnabled = false

    sendReviewButton.tintColor = .lightGray
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
}
