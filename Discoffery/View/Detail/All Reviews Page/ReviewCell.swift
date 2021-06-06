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

  // MARK: - Outlets
  @IBOutlet weak var userImg: UIImageView!

  @IBOutlet weak var userName: UILabel!

  @IBOutlet weak var rateStars: CosmosView!

  @IBOutlet weak var postTime: UILabel!

  @IBOutlet weak var comment: UILabel!

  @IBOutlet weak var itemLabelStackView: UIStackView!

  @IBOutlet weak var noItemLabel: UILabel!

  @IBOutlet weak var imgStackView: UIStackView!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code

    userImg.layer.cornerRadius = 25
  }

  override func prepareForReuse() {

    super.prepareForReuse()

    imgStackView.isHidden = true

    itemLabelStackView.isHidden = true

    imgStackView.arrangedSubviews.map { $0.removeFromSuperview() }

    itemLabelStackView.arrangedSubviews.map { $0.removeFromSuperview() }
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

  func layoutItemLabels(itemsArr: [String]) {

    if !itemsArr.isEmpty {

      itemLabelStackView.isHidden = false
    }

    for index in 0..<itemsArr.count {

      let item = PaddingLabel()

      item.backgroundColor = .B3

      itemLabelStackView.addArrangedSubview(item)

      item.translatesAutoresizingMaskIntoConstraints = false

      item.heightAnchor.constraint(equalToConstant: 30).isActive = true

      item.text = itemsArr[index]
    }
  }

  func layoutImgs(imgsArr: [String]) {

    if !imgsArr.isEmpty {

      imgStackView.isHidden = false
    }

    for index in 0..<imgsArr.count {

      let img = UIImageView()

      imgStackView.addArrangedSubview(img)

      img.translatesAutoresizingMaskIntoConstraints = false

      img.contentMode = .scaleAspectFill

      let imgOriginalWidth = img.image?.size.width

      let imgOriginalHeight = img.image?.size.height

      let imgViewWidth = self.frame.size.width

      img.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 140) / 3).isActive = true

      img.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 140) / 3).isActive = true

      img.loadImage(imgsArr[index])
    }
  }
}
