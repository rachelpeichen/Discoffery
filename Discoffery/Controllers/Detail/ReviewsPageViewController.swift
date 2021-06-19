//
//  ReviewsPageViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/22.
//

import UIKit
import Kingfisher

class ReviewsPageViewController: UIViewController {

  // MARK: - Properties
  var userViewModel = UserViewModel()

  var reviews: [Review]?

  var filteredReviews: [Review] = []

  var blockList: [String] = []

  var shopName = "Cafe Name"

  // MARK: - IBOutlets & IBActions
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var cafeNameLabel: UILabel!
  @IBAction func didTapBackButton(_ sender: Any) {

    self.dismiss(animated: true, completion: nil)
  }

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    cafeNameLabel.text = shopName

    userViewModel.fetchBlockListForReviews(user: UserManager.shared.user)

    userViewModel.onBlockListForReview = { result in

      self.blockList = result

      guard let reviews = self.reviews else { return }

      self.filteredReviews = reviews.filter { !self.blockList.contains( $0.user ) }

      self.setupTableView()
    }
  }

  // MARK: - Functions
  private func setupTableView() {

    tableView.delegate = self
    tableView.dataSource = self
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 200
    tableView.reloadData()
  }

  @objc func didTapCellButton(sender: UIButton) {

    userViewModel.blockUser(user: UserManager.shared.user, blockName: filteredReviews[sender.tag].user)

    sender.isEnabled = false
    sender.setTitle("已封鎖此用戶", for: .disabled)
  }
}

// MARK: - UITableViewDataSource
extension ReviewsPageViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    return filteredReviews.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    if let cell = tableView.dequeueReusableCell(withIdentifier: ReviewCell.identifier, for: indexPath) as? ReviewCell {

      let singleReview = filteredReviews[indexPath.row]

      if singleReview.user == UserManager.shared.user.id {
        cell.blockBtn.isHidden = true

      } else {
        cell.blockBtn.tag = indexPath.row
        cell.blockBtn.addTarget(self, action: #selector(didTapCellButton(sender:)), for: .touchUpInside)
      }

      cell.comment.text = singleReview.comment.isEmpty ? "該用戶無填寫評論" : singleReview.comment
      cell.layoutItemLabel(itemsArr: singleReview.recommendItems)
      cell.layoutImgStackView(imgsArr: singleReview.imgURL)
      cell.layoutReviewCell(review: singleReview)

      return cell
    }
    return ReviewCell()
  }
}

// MARK: - UITableViewDelegate
extension ReviewsPageViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

    return UITableView.automaticDimension
  }

  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {

    return UITableView.automaticDimension
  }
}
