//
//  ReviewsPageViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/22.
//

import UIKit

class ReviewsPageViewController: UIViewController {

  // MARK: Properties
  var reviews: [Review]?

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

    setupTableView() 
  }

  // MARK: Functions
  private func setupTableView() {

    tableView.delegate = self

    tableView.dataSource = self

    tableView.rowHeight = UITableView.automaticDimension

    tableView.estimatedRowHeight = 200

    tableView.reloadData()
  }
}

extension ReviewsPageViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return reviews?.count ?? 3
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    if let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as? ReviewCell {

      if let singleReview = reviews?[indexPath.row] {

        cell.layoutItemLabels(itemsArr: singleReview.recommendItems)

        cell.layoutImgs(imgsArr: singleReview.imgURL)

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
    }
    return ReviewCell()
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
