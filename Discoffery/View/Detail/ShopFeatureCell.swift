//
//  ShopFeatureCell.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/17.
//

import UIKit

class ShopFeatureCell: ShopDetailBasicCell {

  // MARK: - Outlets
  @IBOutlet weak var collectionView: UICollectionView!

  // MARK: - Properties
  var feature = Feature()

  var featureArr: [String] = []

  // MARK: - View Life Cycle
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code

    setupCollectionView()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }

  // MARK: - Functions
  func configure(with featureArr: [String]) {
    
      self.featureArr = featureArr

      self.collectionView.reloadData()

      self.collectionView.layoutIfNeeded()
  }
  
  private func setupCollectionView() {

    collectionView.register(UINib(nibName: FeatureCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: FeatureCollectionViewCell.identifier)

    collectionView.delegate = self

    collectionView.dataSource = self
  }
}

// MARK: - UICollectionViewDataSource
extension ShopFeatureCell: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

    return featureArr.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeatureCollectionViewCell.identifier, for: indexPath) as? FeatureCollectionViewCell {

      cell.layoutFeatureCollectionViewCell(from: featureArr[indexPath.row])

      return cell
    }
    return FeatureCollectionViewCell()
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ShopFeatureCell: UICollectionViewDelegateFlowLayout {

  // MARK: Resize each cell by their text
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    let textSize: CGSize = featureArr[indexPath.row]

      .size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)])

    return CGSize(width: textSize.width + 30, height: 45)
  }
}

extension ShopFeatureCell: UICollectionViewDelegate {
}
