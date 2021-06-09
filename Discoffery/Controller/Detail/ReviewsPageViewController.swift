//
//  ReviewsPageViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/22.
//

import UIKit
import Kingfisher

class ReviewsPageViewController: UIViewController {

  // MARK: Properties
  var userViewModel = UserViewModel()

  var reviews: [Review]?

  var filteredReviews: [Review] = []

  var blockList: [String] = []

  var shopName = "Cafe Name"

  // MARK: Outlets
  @IBOutlet weak var tableView: UITableView!

  @IBOutlet weak var cafeNameLabel: UILabel!

  @IBAction func didTapBackButton(_ sender: Any) {

    self.dismiss(animated: true, completion: nil)
  }
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

extension ReviewsPageViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    return filteredReviews.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    if let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as? ReviewCell {

      let singleReview = filteredReviews[indexPath.row]

      cell.layoutItemLabel(itemsArr: singleReview.recommendItems)

      cell.layoutImgStackView(imgsArr: singleReview.imgURL)

      cell.blockBtn.tag = indexPath.row

      cell.blockBtn.addTarget(self, action: #selector(didTapCellButton(sender:)), for: .touchUpInside)

      cell.postTime.text = Date.dateFormatter.string(from: Date.init(milliseconds: singleReview.postTime))

      cell.rateStars.rating = singleReview.rating

      cell.userName.text = singleReview.userName

      cell.userImg.loadImage(singleReview.userImg)

      if singleReview.comment.isEmpty {
        
        cell.comment.text = "該用戶無填寫評論"

      } else {

        cell.comment.text = singleReview.comment
      }
      return cell
    }
    return ReviewCell()
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

  }

}

extension ReviewsPageViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }

  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
}

//extension ReviewsPageViewController: ReviewCellDelegate {
//
//  func blockUser() {
//    // Do Sth
//  }
//}
