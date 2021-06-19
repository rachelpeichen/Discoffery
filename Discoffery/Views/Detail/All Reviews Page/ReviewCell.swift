//
//  ReviewCell.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/24.
//

import UIKit
import Cosmos
import Kingfisher

class ReviewCell: UITableViewCell {

  // MARK: - IBOutlets
  @IBOutlet weak var blockBtn: UIButton!

  @IBOutlet weak var userName: UILabel!
  @IBOutlet weak var itemTitleLabel: UILabel!
  @IBOutlet weak var postTime: UILabel!
  @IBOutlet weak var comment: UILabel!

  @IBOutlet weak var itemOne: PaddingLabel!
  @IBOutlet weak var itemTwo: PaddingLabel!
  @IBOutlet weak var rateStars: CosmosView!

  @IBOutlet weak var imgStackView: UIStackView!
  @IBOutlet weak var userImg: UIImageView!
  @IBOutlet weak var imgOne: UIImageView!
  @IBOutlet weak var imgTwo: UIImageView!
  @IBOutlet weak var imgThree: UIImageView!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code

    userImg.layer.cornerRadius = 25
    blockBtn.isEnabled = true
  }

  // TODO: Modify image setup dynamically
  override func prepareForReuse() {
    super.prepareForReuse()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

  // MARK: - Layout Cell Related Functions
  func layoutReviewCell(review: Review) {

    postTime.text =  Date.dateFormatter.string(from: Date.init(milliseconds: review.postTime))
    rateStars.rating = review.rating
    userName.text = review.userName
    userImg.loadImage(review.userImg)
  }

  func layoutItemLabel(itemsArr: [String]) {

    switch itemsArr.count {

    case 0:
      itemTitleLabel.isHidden = true
      itemOne.isHidden        = true
      itemTwo.isHidden        = true

    case 1:
      itemOne.isHidden = false
      itemOne.text     = itemsArr[0]
      itemTwo.isHidden = true

    case 2:
      itemOne.isHidden = false
      itemOne.text     = itemsArr[0]
      itemTwo.isHidden = false
      itemTwo.text     = itemsArr[1]

    default:
      
      itemOne.isHidden = false
      itemOne.text     = itemsArr[0]
      itemTwo.isHidden = false
      itemTwo.text     = itemsArr[1]
    }
  }

  func layoutImgStackView(imgsArr: [String]) {

    switch imgsArr.count {

    case 0:
      imgOne.isHidden = true
      imgTwo.isHidden = true
      imgThree.isHidden = true

    case 1:
      imgOne.isHidden = false
      imgTwo.isHidden = false
      imgThree.isHidden  = false

      imgOne.loadImage(imgsArr[0])
      imgOne.backgroundColor   = .white
      imgThree.backgroundColor = .white

    case 2:
      imgOne.isHidden = false
      imgTwo.isHidden = false
      imgThree.isHidden = false

      imgOne.loadImage(imgsArr[0])
      imgTwo.loadImage(imgsArr[1])
      imgThree.backgroundColor = .white

    case 3:
      imgOne.isHidden = false
      imgTwo.isHidden = false
      imgThree.isHidden = false

      imgOne.loadImage(imgsArr[0])
      imgTwo.loadImage(imgsArr[1])
      imgThree.loadImage(imgsArr[2])

    default:
      print(0)
    }
  }
}
