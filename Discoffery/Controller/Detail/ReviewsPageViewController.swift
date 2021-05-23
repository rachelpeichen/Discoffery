//
//  ReviewsPageViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/22.
//

import UIKit

class ReviewsPageViewController: UIViewController {

  // MARK: Outlets
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var cafeName: UILabel!
  @IBAction func didTapBackButton(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }

  // MARK: Properties
  var reviews: [Review]?

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }

  // MARK: Functions
  private func setupTableView() {

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

      cell.comment.text = "很隱密的一家日式咖啡廳，環境很放鬆、很安靜，手沖咖啡很好喝，但品項很少，也沒有特色甜點，只適合辦公或K書。是會一直想光顧的咖啡店。是會一直想光顧的咖啡店。是會一直想光顧的咖啡店。是會一直想光顧的咖啡店。是會一直想光顧的咖啡店。是會一直想光顧的咖啡店。是會一直想光顧的咖啡店。"

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
