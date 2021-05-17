//
//  ShopFeatureCell.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/17.
//

import UIKit

class ShopFeatureCell: ShopDetailBasicCell {

  var features: [String] = []

  @IBOutlet weak var categoryLabel: UILabel!

  @IBOutlet weak var collectionView: UICollectionView!

  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

  // MARK: Functions
  private func setupCollectionView() {

    collectionView.backgroundColor = UIColor.white
  }
}

extension ShopFeatureCell: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

    features.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FeatureCollectionViewCell.self), for: indexPath) as? FeatureCollectionViewCell

    let featureToShow = features[indexPath.row]

    cell?.layoutFeatureCollectionViewCell(hashTag: featureToShow)

    return cell ?? FeatureCollectionViewCell()
  }
}



