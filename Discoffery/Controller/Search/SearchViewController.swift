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
  var searchController: UISearchController!

  var hardCodeKeywordsArr: [String] = ["冷萃咖啡", "檸檬塔", "卡布奇諾", "單品手沖咖啡", "燕麥奶拿鐵", "可麗露", "馥列白", "海鹽焦糖拿鐵", "黃金曼巴", "花香耶加雪菲", "精品檸檬冷萃"]

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.

    setupCollectionView()
  }

  // MARK: - Functions
  func configureSearchController() {

    searchController = UISearchController(searchResultsController: nil)

    searchController.searchResultsUpdater = self
  }

  private func setupCollectionView() {

    collectionView.register(UINib(nibName: "KeywordsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "keywordsCollectionViewCell")

    collectionView.delegate = self

    collectionView.dataSource = self

    collectionView.layoutIfNeeded()
  }
}

extension SearchViewController: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

    return hardCodeKeywordsArr.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "keywordsCollectionViewCell", for: indexPath) as? KeywordsCollectionViewCell {

      cell.layoutKeywordCollectionViewCell(from: hardCodeKeywordsArr[indexPath.row])
      
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

    return CGSize(width: textSize.width + 30, height: 45)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
      return 32
  }
  
}

extension SearchViewController: UICollectionViewDelegate {
  // Do sth
}
