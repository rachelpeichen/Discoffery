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
  var itemArr: [String] = []

  var featureArr: [String] = []

  // MARK: - IBOutlets
  @IBOutlet weak var itemCollectionView: UICollectionView!
  @IBOutlet weak var featureCollectionView: UICollectionView!

  @IBOutlet weak var imgContainerView: UIView!
  @IBOutlet weak var imgView: UIImageView!
  
  @IBOutlet weak var rateStarsView: CosmosView!

  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var distance: UILabel!
  @IBOutlet weak var openHours: UILabel!

  @IBOutlet weak var saveToCollectionBtn: UIButton!
  
  override func awakeFromNib() {
    super.awakeFromNib()

    // Initialization code
    setupCollectionView()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }

  // MARK: Layout functions for ViewControllers to implement
  func configureFeature(with featureArr: [String]) {

    self.featureArr = featureArr
    self.featureCollectionView.reloadData()
    self.featureCollectionView.layoutIfNeeded()
  }

  func configureItem(with itemArr: [String]) {

    self.itemArr = itemArr
    self.itemCollectionView.reloadData()
    self.itemCollectionView.layoutIfNeeded()
  }

  func layoutLandscapeCell(shop: CoffeeShop) {

    // swiftlint:disable force_unwrapping
    let mockImages = ["rect1", "rect2", "rect3", "rect4", "rect5"]
    imgView.image = UIImage(named: mockImages.randomElement()!)
    name.text = shop.name
    distance.text = "距離\(shop.cheap.rounded().formattedValue)公尺"
    rateStarsView.rating = shop.tasty
    openHours.text = "疫情暫停營業"
  }

  // MARK: - Private Functions
  private func setupCollectionView() {

    itemCollectionView.register(UINib(nibName: RecommendItemCollectionViewCell.identifier, bundle: nil),
                                         forCellWithReuseIdentifier: RecommendItemCollectionViewCell.identifier)

    featureCollectionView.register(UINib(nibName: FeatureCollectionViewCell.identifier, bundle: nil),
                                   forCellWithReuseIdentifier: FeatureCollectionViewCell.identifier)

    itemCollectionView.delegate = self
    itemCollectionView.dataSource = self
    featureCollectionView.delegate = self
    featureCollectionView.dataSource = self
    layoutImageViewWithShadow(for: imgView, with: imgContainerView)
  }
}

// MARK: - UICollectionViewDataSource
extension LandscapeCardCell: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

    if collectionView == self.itemCollectionView {
      return 2
    }
    return 3
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    if collectionView == self.itemCollectionView {

      if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendItemCollectionViewCell.identifier,
                                                       for: indexPath) as? RecommendItemCollectionViewCell {
        let item = itemArr[indexPath.row]
        cell.layoutRecommendItemCollectionViewCell(from: item)

        return cell
      }
    } else {

      if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeatureCollectionViewCell.identifier,
                                                       for: indexPath) as? FeatureCollectionViewCell {
        let feature = featureArr[indexPath.row]
        cell.layoutFeatureCollectionViewCell(from: feature)

        return cell
      }
    }
    return FeatureCollectionViewCell()
  }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension LandscapeCardCell: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    if  collectionView == self.itemCollectionView {

      let textSize: CGSize = itemArr[indexPath.row]
        .size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)])

      return CGSize(width: textSize.width + 30, height: 45)

    } else {

      let textSize: CGSize = featureArr[indexPath.row]
        .size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)])

      return CGSize(width: textSize.width + 30, height: 45)
    }
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

      return 8
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

      return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
}

// MARK: - UICollectionViewDelegate
extension LandscapeCardCell: UICollectionViewDelegate {
}
