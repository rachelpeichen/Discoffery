//
//  CollectionCell.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/18.
//

import UIKit

class CollectionCell: UITableViewCell {

  // MARK: Outlets
  @IBOutlet weak var category: UILabel!

  @IBOutlet weak var collectionView: UICollectionView!

  // MARK: Properties
  var mockImages = ["mock_sq1", "mock_sq2", "mock_sq3"]

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

  // MARK: Functions
  private func setupCollectionView() {

    collectionView.backgroundColor = .white
    collectionView.isScrollEnabled = true

    collectionView.register(UINib(nibName: "ProtraitCardCollectionCell", bundle: nil), forCellWithReuseIdentifier: "protraitCardCell")

    setupCollectionViewLayout()
  }

  private func setupCollectionViewLayout() {

    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .horizontal

    flowLayout.itemSize = CGSize(width: 150, height: 250)
    flowLayout.minimumLineSpacing = 6.0

    collectionView.collectionViewLayout = flowLayout
  }
}

extension CollectionCell: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 3
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "protraitCardCell", for: indexPath) as? ProtraitCardCollectionCell {

      cell.image.image = UIImage(named: mockImages[indexPath.row])

      return cell
    }
    return ProtraitCardCollectionCell()
  }
}

extension CollectionCell: UICollectionViewDelegate {
}
