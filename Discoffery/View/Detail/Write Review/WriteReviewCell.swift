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

  var inputItemArr: [String] = []

  var inputRating: Double?

  var inputComment: String?

  // MARK: - Outlets
  @IBOutlet weak var collectionView: UICollectionView!

  @IBOutlet weak var rateStars: CosmosView! {

    didSet {

      rateStars.didFinishTouchingCosmos = { rating in

        self.inputRating = rating

        self.sendReviewButton.isEnabled = true

        self.sendReviewButton.backgroundColor = .B3

        self.sendReviewButton.setTitleColor(.G1, for: .normal)
      }
    }
  }

  @IBOutlet weak var commentTextView: UITextView!

  @IBOutlet weak var addItemTextField: UITextField!

  @IBOutlet weak var sendReviewButton: UIButton!

  // MARK: - Outlets Action
  @IBAction func didEndAddItemText(_ sender: UITextField) {

    if let addItem = sender.text {

      inputItemArr.append(addItem)
    }
    // 刪除就是把array的資料拿掉 按鈕要reload
  }

  @IBAction func addItemCollectionCell(_ sender: UIButton) {

    addItemTextField.text = ""

    showSuccessAlert()

    collectionView.reloadData()
  }

  @IBAction func finishEditingReview(_ sender: UIButton!) {

    showSuccessAlert()

    // The user can send review only when rating is provided
    guard let inputRating = inputRating else { return }

    wrappedReview.rating = inputRating

    wrappedReview.comment = inputComment ?? "User didn't write comment."

    wrappedReview.recommendItems = inputItemArr

    delegate?.sendReview(inputReview: &wrappedReview)

    // If the user did provide recommend item then we can publish
    if !inputItemArr.isEmpty {

      for (index, item) in inputItemArr.enumerated() {

        print("index = \(index) & item = \(item)")

        wrappedRecommendItem.item = item

        // wrappedRecommendItem.count += 1 在這+1會導致count沒更新一直累加送到火地所以在DetailVC檢查：這樣的邏輯變成是這個人推薦了幾個項目count就會是多少！

        delegate?.sendRecommendItem(inputItem: &wrappedRecommendItem)
      }
      inputItemArr.removeAll()
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()

    // Initialization code
    layoutWriteReviewCell()

    setupCollectionView()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }

  // MARK: - Functions
  private func setupCollectionView() {

    collectionView.register(UINib(nibName: "AddItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "addItemCollectionViewCell")

    collectionView.delegate = self

    collectionView.dataSource = self
  }

  func layoutWriteReviewCell() {

    sendReviewButton.isEnabled = false

    sendReviewButton.setTitleColor(.lightGray, for: .disabled)

    sendReviewButton.layoutViewWithShadow()

    commentTextView.delegate = self

    commentTextView.layer.borderColor = UIColor.B1?.cgColor

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

// MARK: - UICollectionViewDataSource
extension WriteReviewCell: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

    return inputItemArr.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addItemCollectionViewCell", for: indexPath) as? AddItemCollectionViewCell {

      cell.layoutAddItemCollectionViewCell(from: inputItemArr[indexPath.row])

      return cell
    }
    return FeatureCollectionViewCell()
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension WriteReviewCell: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    let textSize: CGSize = inputItemArr[indexPath.row]

      .size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)])

    return CGSize(width: textSize.width + 60, height: 40)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 8
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addItemCollectionViewCell", for: indexPath) as? AddItemCollectionViewCell {

      cell.delegate = self

      removeAddedItem(index: indexPath.row)

      collectionView.reloadData()
    }
  }
}

extension WriteReviewCell: UICollectionViewDelegate {
}

// MARK: - AddItemCollectionViewCellDelegate
extension WriteReviewCell: AddItemCollectionViewCellDelegate {

  func removeAddedItem(index: Int) {

    inputItemArr.remove(at: index)

    collectionView.reloadData()
  }
}



// MARK: - UITextViewDelegate
extension WriteReviewCell: UITextViewDelegate {

  func textViewDidEndEditing(_ textView: UITextView) {

    inputComment = textView.text
  }
}
