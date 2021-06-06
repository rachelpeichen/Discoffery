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

  // MARK: - Properties
  var recommendItems: [String] = [] {

    didSet {
      layoutItemLabels()
    }
  }

  var imgsArr: [String] = [] {

    didSet {
      layoutImgs()
    }
  }

  // MARK: - Outlets
  @IBOutlet weak var userImg: UIImageView!

  @IBOutlet weak var userName: UILabel!

  @IBOutlet weak var rateStars: CosmosView!

  @IBOutlet weak var postTime: UILabel!

  @IBOutlet weak var comment: UILabel!

  @IBOutlet weak var itemLabelStackView: UIStackView!

  @IBOutlet weak var itemOne: PaddingLabel!

  @IBOutlet weak var itemTwo: PaddingLabel!

  @IBOutlet weak var itemThree: PaddingLabel!

  @IBOutlet weak var noItemLabel: UILabel!

  @IBOutlet weak var imgStackView: UIStackView!

  @IBOutlet weak var imgOne: UIImageView!

  @IBOutlet weak var imgTwo: UIImageView!

  @IBOutlet weak var imgThree: UIImageView!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code

    userImg.layer.cornerRadius = 25

    layoutItemLabels()

    layoutImgs()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

  func layoutItemLabels() {

    itemLabelStackView.translatesAutoresizingMaskIntoConstraints = false

    switch recommendItems.count {

    case 0:

      noItemLabel.isHidden = false
      itemLabelStackView.removeArrangedSubview(itemOne)
      itemLabelStackView.removeArrangedSubview(itemTwo)
      itemLabelStackView.removeArrangedSubview(itemThree)

    case 1: // MARK: 這是土炮寫法 可用StackView.addArrangedSubview來動態生成

      noItemLabel.isHidden = true
      itemOne.isHidden     = false
      itemOne.text         = recommendItems[0]
      itemTwo.isHidden     = true
      itemThree.isHidden   = true

    case 2:

      noItemLabel.isHidden = true
      itemOne.isHidden     = false
      itemOne.text         = recommendItems[0]
      itemTwo.isHidden     = false
      itemTwo.text         = recommendItems[1]
      itemThree.isHidden   = true

    case 3:

      noItemLabel.isHidden = true
      itemOne.isHidden     = false
      itemOne.text         = recommendItems[0]
      itemTwo.isHidden     = false
      itemTwo.text         = recommendItems[1]
      itemThree.isHidden   = false
      itemThree.text       = recommendItems[2]

    default:

      noItemLabel.isHidden = true
      itemOne.isHidden     = false
      itemOne.text         = recommendItems[0]
      itemTwo.isHidden     = false
      itemTwo.text         = recommendItems[1]
      itemThree.isHidden   = false
      itemThree.text       = recommendItems[2]
    }
  }

  func layoutImgs() {

    imgStackView.translatesAutoresizingMaskIntoConstraints = false

    switch imgsArr.count {

    case 0:

      imgStackView.removeArrangedSubview(imgOne)
      imgStackView.removeArrangedSubview(imgTwo)
      imgStackView.removeArrangedSubview(imgThree)

    case 1:

      imgOne.isHidden     = false
      imgOne.loadImage(imgsArr[0])
      imgTwo.isHidden     = true
      imgThree.isHidden   = true

    case 2:

      imgOne.isHidden     = false
      imgOne.loadImage(imgsArr[0])
      imgTwo.isHidden     = false
      imgTwo.loadImage(imgsArr[1])
      imgThree.isHidden   = true

    case 3:

      imgOne.isHidden     = false
      imgOne.loadImage(imgsArr[0])
      imgTwo.isHidden     = false
      imgTwo.loadImage(imgsArr[1])
      imgThree.isHidden   = false
      imgThree.loadImage(imgsArr[2])

    default:

      imgOne.isHidden     = false
      imgOne.loadImage(imgsArr[0])
      imgTwo.isHidden     = false
      imgTwo.loadImage(imgsArr[1])
      imgThree.isHidden   = false
      imgThree.loadImage(imgsArr[2])
    }
  }
}
