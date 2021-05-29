//
//  ReviewCell.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/24.
//

import UIKit
import Cosmos

class ReviewCell: UITableViewCell {

  // MARK: - Properties
  var recommendItems: [String] = []

  // MARK: - Outlets
  @IBOutlet weak var collectionView: UICollectionView!

  @IBOutlet weak var userImage: UIImageView!

  @IBOutlet weak var userName: UILabel!

  @IBOutlet weak var rateStars: CosmosView!

  @IBOutlet weak var postTIme: UILabel!

  @IBOutlet weak var comment: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code

    userImage.layer.cornerRadius = 25

    setupCollectionView()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

  // MARK: - Functions
  private func setupCollectionView() {

    collectionView.register(UINib(nibName: "FeatureCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "featureCollectionCell")

    collectionView.delegate = self

    collectionView.dataSource = self
  }
}

extension ReviewCell: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return recommendItems.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "featureCollectionCell", for: indexPath) as? FeatureCollectionViewCell {

      let feature = recommendItems[indexPath.row]

      cell.layoutFeatureCollectionViewCell(feature: feature)

      return cell
    }
    return FeatureCollectionViewCell()
  }
}

extension ReviewCell: UICollectionViewDelegateFlowLayout {

  // MARK: 以字體內容去調整每個cell的大小
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    let textSize: CGSize = recommendItems[indexPath.row]

      .size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)])

    return CGSize(width: textSize.width + 22, height: 45)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return 0
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
      return 0
  }
}

extension ReviewCell: UICollectionViewDelegate {
}
