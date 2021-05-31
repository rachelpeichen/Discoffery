//
//  SearchViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/31.
//

import UIKit

class SearchViewController: UIViewController {

  // MARK: - Outlets
  @IBOutlet weak var searchBar: UISearchBar!

  @IBOutlet weak var collectionView: UICollectionView!

  @IBAction func backToHomeView(_ sender: Any) {

    self.dismiss(animated: true, completion: nil)
  }

  // MARK: - Properties
  var hardCodeKeywordsArr: [String] = ["冷萃咖啡", "檸檬塔", "卡布奇諾", "單品手沖咖啡", "燕麥奶拿鐵", "可麗露", "馥列白", "海鹽焦糖拿鐵", "黃金曼巴", "花香耶加雪菲", "精品檸檬冷萃", "蜂蜜鮮奶茶", "法式可可歐蕾", "田園雞肉帕里尼", "藍莓瑪芬", "法式千層薄餅", "文青風格","店貓很可愛","環境舒適悠閒","提供外帶","冠軍拉花", "販售咖啡豆","手沖咖啡教學","店員親切","北歐風裝潢","老屋咖啡廳"]

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    configureFeature(with: hardCodeKeywordsArr)

    setupCollectionView()
  }

  // MARK: - Functions
  private func setupCollectionView() {

    collectionView.register(UINib(nibName: "FeatureCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "featureCollectionCell")

    collectionView.delegate = self

    collectionView.dataSource = self
  }

   private func configureFeature(with featureArr: [String]) {

    self.hardCodeKeywordsArr = featureArr

    self.collectionView.reloadData()

    self.collectionView.layoutIfNeeded()
  }
}

extension SearchViewController: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

    return hardCodeKeywordsArr.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "featureCollectionCell", for: indexPath) as? FeatureCollectionViewCell {

      cell.layoutFeatureCollectionViewCell(from: hardCodeKeywordsArr[indexPath.row])

      return cell
    }
    return FeatureCollectionViewCell()
  }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {

  // MARK: Resize each cell by their text
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    let textSize: CGSize = hardCodeKeywordsArr[indexPath.row]

      .size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)])

    return CGSize(width: textSize.width + 30, height: collectionView.bounds.size.height)
  }
}

extension SearchViewController: UICollectionViewDelegate {

}

