//
//  SearchViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/31.
//

import UIKit

class SearchViewController: UIViewController {

  // MARK: - Properties
  var searchViewModel = SearchViewModel()

  var inputKeyword: String?

  // swiftlint:disable line_length
  let hardCodeKeywordsArr: [String] = ["冷萃咖啡", "檸檬塔", "法式可可歐蕾", "海鹽焦糖拿鐵", "卡布奇諾", "單品手沖咖啡", "燕麥奶拿鐵", "可麗露", "黃金曼巴", "花香耶加雪菲", "精品檸檬冷萃"]

  // MARK: - IBOutlets
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var collectionView: UICollectionView!

  // MARK: - IBActions
  @IBAction func backToHomeView(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    setupCollectionView()
    searchBar.delegate = self
  }

  // MARK: - Prepare For Segue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if let resultVC = segue.destination as? SearchResultViewController {

      guard let keyword = inputKeyword else { return }
      resultVC.keyword = keyword
    }
  }

  // MARK: - Private Functions
  private func setupCollectionView() {

    collectionView.register(UINib(nibName: KeywordCollectionViewCell.identifier, bundle: nil),
                            forCellWithReuseIdentifier: KeywordCollectionViewCell.identifier)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.layoutIfNeeded()
  }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.text = ""
  }

  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {

    if let keyword = searchBar.text {
      inputKeyword = keyword
      performSegue(withIdentifier: "navigateToSearchResultVC", sender: self)
    }
  }
}

// MARK: - UICollectionViewDataSource
extension SearchViewController: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return hardCodeKeywordsArr.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeywordCollectionViewCell.identifier,
                                                     for: indexPath) as? KeywordCollectionViewCell {

      cell.layoutKeywordCollectionViewCell(from: hardCodeKeywordsArr[indexPath.row])
      cell.keywordBtn.addTarget(self, action: #selector(didTapKeywordBtn(sender:)), for: .allTouchEvents)

      return cell
    }
    return KeywordCollectionViewCell()
  }

  @objc func didTapKeywordBtn(sender: UIButton) {

    if let input = sender.title(for: .normal) {
      inputKeyword = input
      performSegue(withIdentifier: "navigateToSearchResultVC", sender: sender)
    }
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    // Resize each cell by their text size
    let textSize: CGSize = hardCodeKeywordsArr[indexPath.row]

      .size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)])

    return CGSize(width: textSize.width + 30, height: 45)
  }

  func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {

    // If the cell's size has to be exactly the content
    // Size of the collection View, just return the
    // collectionViewLayout's collectionViewContentSize.

    collectionView.frame = CGRect(x: 0, y: 0, width: targetSize.width, height: 600)

    collectionView.layoutIfNeeded()

    // It tells what size is required for the CollectionView
    return collectionView.collectionViewLayout.collectionViewContentSize
  }
}

// MARK: - UICollectionViewDelegate
extension SearchViewController: UICollectionViewDelegate {

}
