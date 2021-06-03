//
//  WriteReviewCell.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/17.
//

import UIKit
import Cosmos
import Kingfisher

protocol WriteReviewCellDelegate: AnyObject {

  func sendReview(inputReview: inout Review)

  func sendRecommendItem(inputItem: inout RecommendItem)

  func uploadImageBtnDidSelect()
}

class WriteReviewCell: ShopDetailBasicCell {

  // MARK: - Properties
  
  weak var delegate: WriteReviewCellDelegate?

  var wrappedReview = Review()

  var wrappedRecommendItem = RecommendItem()

  var endEditItem: String?

  var inputItemArr: [String] = []

  var inputRating: Double?

  var inputComment: String?

  var uploadedImages: [String] = []

  // MARK: - Outlets
  @IBOutlet weak var collectionView: UICollectionView!

  @IBOutlet weak var rateStars: CosmosView! {

    didSet {

      rateStars.didFinishTouchingCosmos = { rating in

        self.inputRating = rating

        self.sendReviewBtn.isEnabled = true

        self.sendReviewBtn.backgroundColor = .B3

        self.sendReviewBtn.setTitleColor(.G1, for: .normal)

        self.uploadImageBtn.isEnabled = true

        self.uploadImageBtn.setTitleColor(.G1, for: .normal)

        self.uploadImageBtn.tintColor = .G1
      }
    }
  }

  @IBOutlet weak var commentTextView: UITextView!

  @IBOutlet weak var addItemTextField: UITextField!

  @IBOutlet weak var uploadImageBtn: UIButton!

  @IBOutlet weak var sendReviewBtn: UIButton!

  @IBOutlet weak var uploadImageOne: UIImageView!

  @IBOutlet weak var uploadImageTwo: UIImageView!

  @IBOutlet weak var uploadImageThree: UIImageView!

  // MARK: - Outlets Action
  @IBAction func didEndAddItemText(_ sender: UITextField) {

    if let addItem = sender.text {

      endEditItem = addItem
    }
  }

  @IBAction func addItemCollectionCell(_ sender: UIButton) {

    if let endEditItem = endEditItem {

      inputItemArr.append(endEditItem)

      addItemTextField.text = ""

      collectionView.reloadData()
    }
  }

  @IBAction func uploadImage(_ sender: UIButton) {

    delegate?.uploadImageBtnDidSelect()
  }

  @IBAction func finishEditingReview(_ sender: UIButton!) {

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
      rateStars.rating = 0

      addItemTextField.text = ""

      commentTextView.text = ""

      inputItemArr.removeAll()

      collectionView.reloadData()
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

    sendReviewBtn.isEnabled = false

    sendReviewBtn.setTitleColor(.lightGray, for: .disabled)

    sendReviewBtn.layoutViewWithShadow()

    sendReviewBtn.layoutViewWithShadow()

    uploadImageBtn.isEnabled = false

    uploadImageBtn.setTitleColor(.lightGray, for: .disabled)

    addItemTextField.clipsToBounds = true

    addItemTextField.layer.cornerRadius = 10

    addItemTextField.layer.borderWidth = 0.5

    addItemTextField.layer.borderColor = UIColor.B5?.cgColor

    commentTextView.delegate = self

    commentTextView.layer.borderWidth = 0.5

    commentTextView.layer.borderColor = UIColor.B5?.cgColor

    commentTextView.clipsToBounds = true

    commentTextView.layer.cornerRadius = 10

//    uploadImageOne.isHidden = true
//
//    uploadImageTwo.isHidden = true
//
//    uploadImageThree.isHidden = true
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

      inputItemArr.remove(at: indexPath.row)

      collectionView.reloadData()
    }
  }
}

extension WriteReviewCell: UICollectionViewDelegate {
}

// MARK: - UITextViewDelegate
extension WriteReviewCell: UITextViewDelegate {

  func textViewDidEndEditing(_ textView: UITextView) {

    inputComment = textView.text
  }
}
