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
  var featuresArr: [String] = [] {

    didSet {

      collectionView.reloadData()
    }
  }

  @IBOutlet weak var imageContainerView: UIView!

  @IBOutlet weak var cafeMainImage: UIImageView!

  @IBOutlet weak var collectionView: UICollectionView!

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

  private func setupCollectionView() {

    collectionView.register(UINib(nibName: "FeatureCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "featureCollectionCell")

    collectionView.delegate = self

    collectionView.dataSource = self
  }
}

extension LandscapeCardCell: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return featuresArr.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "featureCollectionCell", for: indexPath) as? FeatureCollectionViewCell {

      let feature = featuresArr[indexPath.row]
      
      cell.layoutFeatureCollectionViewCell(feature: feature)

      return cell
    }
    return FeatureCollectionViewCell()
  }
}

extension LandscapeCardCell: UICollectionViewDelegateFlowLayout {

  // MARK: 以字體內容去調整每個cell的大小
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    let textSize: CGSize = featuresArr[indexPath.row]

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

extension LandscapeCardCell: UICollectionViewDelegate {
}
