//
//  LandscapeCardCell.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/13.
//

import UIKit
import Cosmos

class LandscapeCardCell: UITableViewCell {

  // MARK: - Properties
  var itemLayoutArr: [String] = []

  var featureLayoutArr: [String] = []

  @IBOutlet weak var imageContainerView: UIView!

  @IBOutlet weak var cafeMainImage: UIImageView!

  @IBOutlet weak var recommendItemCollectionView: UICollectionView!

  @IBOutlet weak var featureCollectionView: UICollectionView!

  @IBOutlet weak var cafeName: UILabel!

  @IBOutlet weak var starsView: CosmosView!

  @IBOutlet weak var distance: UILabel!

  @IBOutlet weak var openHours: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code

    layoutLandscapeCardCell()
    
    setupCollectionView()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

  // MARK: - Functions
  func layoutLandscapeCardCell() {

    layoutImageView(for: cafeMainImage, with: imageContainerView)
  }

  func configureFeature(with featureArr: [String]) {

    self.featureLayoutArr = featureArr

    self.featureCollectionView.reloadData()

    self.featureCollectionView.layoutIfNeeded()
  }

  func configureItem(with itemArr: [String]) {

    self.itemLayoutArr = itemArr

    self.recommendItemCollectionView.reloadData()

    self.recommendItemCollectionView.layoutIfNeeded()
  }

  private func setupCollectionView() {

    recommendItemCollectionView.register(UINib(nibName: "RecommendItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "recommendItemCollectionCell")

    featureCollectionView.register(UINib(nibName: "FeatureCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "featureCollectionCell")

    recommendItemCollectionView.delegate = self

    recommendItemCollectionView.dataSource = self

    featureCollectionView.delegate = self

    featureCollectionView.dataSource = self
  }
}

extension LandscapeCardCell: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

    if collectionView == self.recommendItemCollectionView {

      return itemLayoutArr.count
    }

    return featureLayoutArr.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    if collectionView == self.recommendItemCollectionView {

      if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recommendItemCollectionCell", for: indexPath) as? RecommendItemCollectionViewCell {

        let item = itemLayoutArr[indexPath.row]

        cell.layoutRecommendItemCollectionViewCell(from: item)

        return cell
      }

    } else {

      if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "featureCollectionCell", for: indexPath) as? FeatureCollectionViewCell {

        let feature = featureLayoutArr[indexPath.row]

        cell.layoutFeatureCollectionViewCell(from: feature)

        return cell
      }
    }
    return FeatureCollectionViewCell()
  }

}

extension LandscapeCardCell: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    if  collectionView == self.recommendItemCollectionView {

      let textSize: CGSize = itemLayoutArr[indexPath.row]

        .size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)])

      return CGSize(width: textSize.width + 30, height: 45)

    } else {

      let textSize: CGSize = featureLayoutArr[indexPath.row]

        .size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)])

      return CGSize(width: textSize.width + 30, height: 45)
    }

  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}

extension LandscapeCardCell: UICollectionViewDelegate {
}
