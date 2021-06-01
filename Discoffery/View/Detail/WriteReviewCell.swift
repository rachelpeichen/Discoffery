//
//  WriteReviewCell.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/17.
//

import UIKit
import Cosmos
import JGProgressHUD

protocol WriteReviewCellDelegate: AnyObject {

  func sendReview(inputReview: inout Review)

  func sendRecommendItem(inputItem: inout RecommendItem)
}

class WriteReviewCell: ShopDetailBasicCell {

  // MARK: - Properties
  weak var delegate: WriteReviewCellDelegate?

  var wrappedReview = Review()

  var wrappedRecommendItem = RecommendItem()

  var inputItem: [String] = []

  var inputRating: Double?

  // MARK: - Outlets
  @IBOutlet weak var reviewComment: UITextView!

  @IBOutlet weak var recommendItem: UITextField!

  @IBOutlet weak var recommendItem2: UITextField!

  @IBOutlet weak var rateStars: CosmosView! {

    didSet {

      rateStars.didFinishTouchingCosmos = { rating in

        self.inputRating = rating

        self.sendReviewButton.isEnabled = true

        self.sendReviewButton.backgroundColor = .B4
      }
    }
  }

  // MARK: 拍照按鈕還沒弄
  @IBOutlet weak var uploadPhotosButton: UIButton!

  // 只先給輸入一個 其他用按鈕寫死ㄉ按鈕也還沒弄

  @IBAction func addNewRecommendItem(_ sender: Any) {

    recommendItem2.isHidden = false
  }

  @IBOutlet weak var sendReviewButton: UIButton!

  // MARK: - Outlets' Action

  @IBAction func didEndEditingItem(_ sender: UITextField) {

    inputItem.append(sender.text ?? "none")
  }

  @IBAction func finishEditingReview(_ sender: UIButton!) {

    showSuccessAlert()

    // The user can send review only when rating is provided
    guard let inputRating = inputRating else { return }

    wrappedReview.rating = inputRating

    wrappedReview.comment = reviewComment.text ?? "User didn't write comment."

    wrappedReview.recommendItems = inputItem

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

    sendReviewButton.addShadow()

    reviewComment.addShadow()

    recommendItem2.isHidden = true
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }

  // MARK: - Functions 待整理

  func showSuccessAlert() {

    let hud = JGProgressHUD()

    hud.indicatorView = JGProgressHUDSuccessIndicatorView()

    hud.textLabel.text = "Success"

    hud.show(in: self, animated: true)

    hud.dismiss(afterDelay: 2.0)

    reviewComment.text = ""

    recommendItem.text = ""

    recommendItem2.text = ""
  }
}

// extension WriteReviewCell: UITextViewDelegate {
//
//  func textViewDidChange(_ textView: UITextView) {
//      // Refresh tableView cell
//      if textView.numberOfLines > 2 { // textView in storyboard has two lines, so we match the design
//          // Animated height update
//          DispatchQueue.main.async {
//              self.tableView?.beginUpdates()
//              self.tableView?.endUpdates()
//          }
//      }
//  }
//}
