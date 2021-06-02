//
//  ReviewsPageViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/22.
//

import UIKit

class ReviewsPageViewController: UIViewController, UITableViewDelegate {

  // MARK: Outlets
  @IBOutlet weak var tableView: UITableView!

  @IBOutlet weak var cafeNameLabel: UILabel!

  @IBAction func didTapBackButton(_ sender: Any) {

    self.dismiss(animated: true, completion: nil)
  }

  // MARK: Properties
  var reviews: [Review]?

  var shopName = "Cafe Name"

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    cafeNameLabel.text = shopName
  }

  // MARK: Functions
  private func setupTableView() {

    tableView.delegate = self

    tableView.dataSource = self

    tableView.estimatedRowHeight = 200

    tableView.rowHeight = UITableView.automaticDimension

    tableView.reloadData()
  }
}

extension ReviewsPageViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return reviews?.count ?? 3
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    if let cell = tableView.dequeueReusableCell(
        withIdentifier: "reviewCell", for: indexPath) as? ReviewCell {

      guard let singleReview = reviews?[indexPath.row] else { return ReviewCell() }

      cell.recommendItems = singleReview.recommendItems

      cell.postTime.text = Date.dateFormatter.string(from: Date.init(milliseconds: singleReview.postTime))

      cell.rateStars.rating = singleReview.rating

      cell.userName.text = singleReview.userName

      if singleReview.comment.isEmpty {

        cell.comment.text = "該用戶無填寫評論"

      } else {
        
        cell.comment.text = singleReview.comment
      }

      return cell
    }
    return ReviewCell()
  }
}

//
// class HomeViewController: UIViewController {
//
// private enum ButtonSet: String {
//
//    case map = "地圖模式"
//
//    case list = "列表模式"
//  }
//
//  // MARK: - Outlets
//  @IBOutlet weak var selectionView: SelectionView! {
//
//    didSet {
//
//      selectionView.dataSource = self
//
//      selectionView.delegate = self
//    }
//  }
//
//  @IBOutlet weak var mapContainerView: UIView!
//
//  @IBOutlet weak var listContainerView: UIView!
//
//  // MARK: - Properties
//  private let buttonArray: [ButtonSet] = [.map, .list]
//
//  // MARK: - View Life Cycle
//  override func viewDidLoad() {
//    super.viewDidLoad()
//
//    // Do any additional setup after loading the view.
//    selectionView.backgroundColor = .white
//
//    mapContainerView.isHidden = false
//
//    listContainerView.isHidden = true
//  }
//
//  // MARK: - Navigation
//  // In a storyboard-based application, you will often want to do a little preparation before navigation
//  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//      // Get the new view controller using segue.destination.
//      // Pass the selected object to the new view controller.
//      if segue.identifier == "navigateToDetailVC",
//
//         let detailViewController = segue.destination as? DetailViewController {
//
//      }
//  }
// }
//
//// MARK: - SelectionViewDataSource
//extension HomeViewController: SelectionViewDataSource {
//
//  func titleOfButton(_ selectionView: SelectionView, at index: Int) -> String {
//    return buttonArray[index].rawValue
//  }
//
//  func colorOfTitle(_ selectionView: SelectionView, at index: Int) -> UIColor? {
//    return .darkGray
//  }
//
//  func fontOfTitle(_ selectionView: SelectionView, at index: Int) -> UIFont {
//    return .systemFont(ofSize: 14)
//  }
// }
//
//  MARK: - SelectionViewDelegate
// extension HomeViewController: SelectionViewDelegate {
//
//  func didSelectedButton(_ selectionView: SelectionView, at index: Int) {
//
//    if selectionView == selectionView {
//
//      if index == 1 {
//
//        mapContainerView.isHidden = true
//
//        listContainerView.isHidden = false
//      } else {
//
//        mapContainerView.isHidden = false
//
//        listContainerView.isHidden = true
//      }
//    }
//  }
// }
