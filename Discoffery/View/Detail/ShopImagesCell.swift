//
//  ShopImagesCell.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/17.
//

import UIKit

class ShopImagesCell: ShopDetailBasicCell {

  // MARK: Outlets
  @IBOutlet weak var collectionView: UICollectionView!

  // MARK: Properties
  var mockImages = ["mock_sq1", "mock_sq2", "mock_sq3"]

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code

    setupCollectionView()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

  // MARK: Functions
  private func setupCollectionView() {

    collectionView.register(UINib(nibName: "ShopImagesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "imagesCollectionCell")

    collectionView.dataSource = self

    collectionView.delegate = self

    collectionView.isScrollEnabled = true

    collectionView.showsHorizontalScrollIndicator = true
  }
}

extension ShopImagesCell: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 3
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imagesCollectionCell", for: indexPath) as? ShopImagesCollectionViewCell {

      cell.tmpMainImage.image = UIImage(named: mockImages[indexPath.row])

      return cell
    }
    return ShopImagesCollectionViewCell()
  }
}

extension ShopImagesCell: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

      return 4.0
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    return CGSize(width: 400, height: 400)
  }
}

extension ShopImagesCell: UICollectionViewDelegate {   
}
