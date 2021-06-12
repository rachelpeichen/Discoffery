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

  func uploadImageBtnDidSelect()
}

class WriteReviewCell: ShopDetailBasicCell {

  // MARK: - Properties
  var userViewModel = UserViewModel()

  weak var delegate: WriteReviewCellDelegate?

  var wrappedReview = Review()

  var wrappedRecommendItem = RecommendItem()

  var addedItem: String?

  // MARK: - IBOutlets
  @IBOutlet weak var collectionView: UICollectionView!

  @IBOutlet weak var rateStars: CosmosView! {

    didSet {

      rateStars.didFinishTouchingCosmos = { rating in

        self.wrappedReview.rating = rating

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

  @IBOutlet weak var uploadImgOne: UIImageView!

  @IBOutlet weak var uploadImgTwo: UIImageView!

  @IBOutlet weak var uploadImgThree: UIImageView!

  // MARK: - IBActions
  @IBAction func didEndAddItemText(_ sender: UITextField) {

    if let input = sender.text {

      if !input.isEmpty {

        addedItem = input
      }
    }
  }

  @IBAction func onTapAddItemBtn(_ sender: UIButton) {

    guard let addedItem = addedItem else { return }

    wrappedReview.recommendItems.append(addedItem)

    addItemTextField.text = ""

    collectionView.reloadData()
  }

  @IBAction func uploadImage(_ sender: UIButton) {

    delegate?.uploadImageBtnDidSelect()
  }

  @IBAction func onTapSendBtn(_ sender: UIButton!) {

    // The user can send review only when rating is provided
    if wrappedReview.rating != 0 {

      delegate?.sendReview(inputReview: &wrappedReview)

      // If the user did provide recommend item then we can publish
      if !wrappedReview.recommendItems.isEmpty {

        for (index, item) in wrappedReview.recommendItems.enumerated() {

          print("index = \(index) & item = \(item)")

          wrappedRecommendItem.item = item

          // wrappedRecommendItem.count += 1 在這+1會導致count沒更新一直累加送到火地所以在DetailVC檢查：這樣的邏輯變成是這個人推薦了幾個項目count就會是多少！

          delegate?.sendRecommendItem(inputItem: &wrappedRecommendItem)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {

          self.clearWriteReviewCell()

          self.collectionView.reloadData()
        }
      }
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()

    // Initialization code
    layoutWriteReviewCell()

    setupCollectionView()

    userViewModel.watchUser()

    userViewModel.onWatchUser = { result in

      self.wrappedReview.userImg = result.profileImg

      self.wrappedReview.user = result.id

      self.wrappedReview.userName = result.name
    }
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

    uploadImageBtn.isEnabled = false
    uploadImageBtn.setTitleColor(.lightGray, for: .disabled)

    commentTextView.delegate           = self
    commentTextView.layer.borderWidth  = 0.5
    commentTextView.layer.borderColor  = UIColor.B5?.cgColor
    commentTextView.clipsToBounds      = true
    commentTextView.layer.cornerRadius = 10

    uploadImgOne.isHidden   = true
    uploadImgTwo.isHidden   = true
    uploadImgThree.isHidden = true
  }

  func clearWriteReviewCell() {

    rateStars.rating        = 0
    addItemTextField.text   = ""
    commentTextView.text    = ""
    wrappedReview.recommendItems.removeAll()
    uploadImgOne.isHidden   = true
    uploadImgTwo.isHidden   = true
    uploadImgThree.isHidden = true
  }
}

// MARK: - UICollectionViewDataSource
extension WriteReviewCell: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

    return wrappedReview.recommendItems.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addItemCollectionViewCell", for: indexPath) as? AddItemCollectionViewCell {

      cell.layoutAddItemCollectionViewCell(from: wrappedReview.recommendItems[indexPath.row])

      return cell
    }
    return FeatureCollectionViewCell()
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension WriteReviewCell: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    let textSize: CGSize = wrappedReview.recommendItems[indexPath.row]

      .size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)])

    return CGSize(width: textSize.width + 60, height: 40)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 8
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    if collectionView.dequeueReusableCell(withReuseIdentifier: "addItemCollectionViewCell", for: indexPath) is AddItemCollectionViewCell {

      wrappedReview.recommendItems.remove(at: indexPath.row)

      collectionView.reloadData()
    }
  }
}

extension WriteReviewCell: UICollectionViewDelegate {
}

// MARK: - UITextViewDelegate
extension WriteReviewCell: UITextViewDelegate {

  func textViewDidEndEditing(_ textView: UITextView) {

    wrappedReview.comment = textView.text
  }
}
