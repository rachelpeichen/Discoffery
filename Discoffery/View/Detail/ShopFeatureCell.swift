//
//  ShopFeatureCell.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/17.
//

import UIKit

class ShopFeatureCell: ShopDetailBasicCell {

  // MARK: - Properties
  var feature = Feature()

  var featureArr = [String]()

  @IBOutlet weak var collectionView: UICollectionView!

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

    collectionView.register(UINib(nibName: "FeatureCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "featureCollectionCell")

    collectionView.delegate = self

    collectionView.dataSource = self
  }
}

extension ShopFeatureCell: UICollectionViewDataSource {

  // MARK: 先寫死三個
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 3
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "featureCollectionCell", for: indexPath) as? FeatureCollectionViewCell {

      cell.layoutFeatureCollectionViewCell(feature: featureArr[indexPath.row])

      return cell
    }
    return FeatureCollectionViewCell()
  }
}

extension ShopFeatureCell: UICollectionViewDelegateFlowLayout {

  // MARK: 以字體內容去調整每個cell的大小
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    let textSize: CGSize = featureArr[indexPath.row]

      .size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)])

    return CGSize(width: textSize.width + 30, height: collectionView.bounds.size.height)
  }
}

extension ShopFeatureCell: UICollectionViewDelegate {
}
