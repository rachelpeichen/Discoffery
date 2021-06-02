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

  var inputComment: String?

  // MARK: - Outlets
  @IBOutlet weak var rateStars: CosmosView! {

    didSet {

      rateStars.didFinishTouchingCosmos = { rating in

        self.inputRating = rating

        self.sendReviewButton.isEnabled = true

        self.sendReviewButton.backgroundColor = .B3
      }
    }
  }

  @IBOutlet weak var commentTextView: UITextView!

  @IBOutlet weak var sendReviewButton: UIButton!

  // MARK: - Outlets' Action

  @IBAction func finishEditingReview(_ sender: UIButton!) {

    showSuccessAlert()

    // The user can send review only when rating is provided
    guard let inputRating = inputRating else { return }

    wrappedReview.rating = inputRating

    wrappedReview.comment = inputComment ?? "User didn't write comment."

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
    layoutWriteReviewCell()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }

  // MARK: - Functions 待整理
  func layoutWriteReviewCell() {

    sendReviewButton.isEnabled = false

    sendReviewButton.layoutViewWithShadow()

    commentTextView.delegate = self

    commentTextView.layer.borderColor = UIColor.G2?.cgColor

    commentTextView.layer.borderWidth = 0.5

    commentTextView.clipsToBounds = true

    commentTextView.layer.cornerRadius = 10
  }

  func showSuccessAlert() {

    let hud = JGProgressHUD()

    hud.indicatorView = JGProgressHUDSuccessIndicatorView()

    hud.textLabel.text = "Success"

    hud.show(in: self, animated: true)

    hud.dismiss(afterDelay: 2.0)

    commentTextView.text = ""
  }
}

// MARK: UITextViewDelegate
extension WriteReviewCell: UITextViewDelegate {

  func textViewDidChange(_ textView: UITextView) {

    let fixedWidth = textView.frame.size.width

    textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))

    let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))

    var newFrame = textView.frame

    newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)

    textView.frame = newFrame
  }

  func textViewDidEndEditing(_ textView: UITextView) {

    inputComment = textView.text
  }
}
