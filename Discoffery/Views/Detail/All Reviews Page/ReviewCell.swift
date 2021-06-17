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

  @IBOutlet weak var userImg: UIImageView!

  @IBOutlet weak var userName: UILabel!

  @IBOutlet weak var itemTitleLabel: UILabel!

  @IBOutlet weak var itemOne: PaddingLabel!

  @IBOutlet weak var itemTwo: PaddingLabel!
  
  @IBOutlet weak var rateStars: CosmosView!

  @IBOutlet weak var postTime: UILabel!

  @IBOutlet weak var comment: UILabel!

  @IBOutlet weak var imgStackView: UIStackView!

  @IBOutlet weak var imgOne: UIImageView!

  @IBOutlet weak var imgTwo: UIImageView!

  @IBOutlet weak var imgThree: UIImageView!

  @IBAction func onTapBlockBtn(_ sender: Any) {

  }

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code

    userImg.layer.cornerRadius = 25
    blockBtn.isEnabled = true
  }

  override func prepareForReuse() {
    super.prepareForReuse()
//    imgStackView.arrangedSubviews.map { $0.removeFromSuperview() }
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

  func layoutItemLabel(itemsArr: [String]) {

    switch itemsArr.count {

    case 0:

      itemTitleLabel.isHidden = true
      itemOne.isHidden = true
      itemTwo.isHidden = true

    case 1:

      itemOne.isHidden = false
      itemOne.text = itemsArr[0]
      itemTwo.isHidden = true

    case 2:

      itemOne.isHidden = false
      itemOne.text = itemsArr[0]
      itemTwo.isHidden = false
      itemTwo.text = itemsArr[1]

    default:
      
      itemOne.isHidden = false
      itemOne.text = itemsArr[0]
      itemTwo.isHidden = false
      itemTwo.text = itemsArr[1]
    }
  }

  func layoutImgStackView(imgsArr: [String]) {

    // 變形的那張照片原始尺寸不是正方形的 其他的都是正方形
    switch imgsArr.count {

    case 0:

      imgOne.isHidden = true
      imgTwo.isHidden = true
      imgThree.isHidden = true

    case 1:

      imgOne.isHidden = false
      imgOne.loadImage(imgsArr[0])
      imgTwo.isHidden = false
      imgOne.backgroundColor = .white
      imgThree.isHidden = false
      imgThree.backgroundColor = .white

    case 2:

      imgOne.isHidden = false
      imgOne.loadImage(imgsArr[0])
      imgTwo.isHidden = false
      imgTwo.loadImage(imgsArr[1])
      imgThree.isHidden = false
      imgThree.backgroundColor = .white

    case 3:

      imgOne.isHidden = false
      imgOne.loadImage(imgsArr[0])
      imgTwo.isHidden = false
      imgTwo.loadImage(imgsArr[1])
      imgThree.isHidden = false
      imgThree.loadImage(imgsArr[2])

    default:
      print(0)
    }
  }

//  func layoutImgs(imgsArr: [String]) {
//
//    if !imgsArr.isEmpty {
//
//      imgStackView.isHidden = false
//    }
//
//    for index in 0..<imgsArr.count {
//
//      let img = UIImageView()
//
//      imgStackView.addArrangedSubview(img)
//
//      img.translatesAutoresizingMaskIntoConstraints = false
//
//      img.contentMode = .scaleAspectFill
//
//      img.centerXAnchor.constraint(equalTo: img.centerXAnchor).isActive = true
//
//      img.centerYAnchor.constraint(equalTo: img.centerYAnchor).isActive = true
//
//     img.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 140) / 3).isActive = true
//
//   img.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 140) / 3).isActive = true
//
//      img.loadImage(imgsArr[index])
//    }
//  }
}
