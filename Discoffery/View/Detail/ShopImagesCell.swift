//
//  ShopImagesCell.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/17.
//

import UIKit

class ShopImagesCell: ShopDetailBasicCell {

  var images: [String] = []

  @IBOutlet weak var collectionView: UICollectionView!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code

    collectionView.dataSource = self

    collectionView.delegate = self

    setupCollectionView()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

  private func setupCollectionView() {

    collectionView.backgroundColor = .white

    collectionView.isScrollEnabled = true

    collectionView.register(UINib(nibName: "ShopImagesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "imagesCollectionCell")

    setupCollectionViewLayout()
  }

  private func setupCollectionViewLayout() {

    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .horizontal

    flowLayout.itemSize = CGSize(width: 300, height: 300)
    flowLayout.minimumLineSpacing = 6.0

    collectionView.collectionViewLayout = flowLayout
  }
}

extension ShopImagesCell: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 3
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imagesCollectionCell", for: indexPath) as? ShopImagesCollectionViewCell {

      cell.tmpMainImage.image = UIImage(named: "mock_1")

      return cell
    }
    return ShopImagesCollectionViewCell()
  }
}

extension ShopImagesCell: UICollectionViewDelegate {
  
}
