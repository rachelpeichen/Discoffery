//
//  HomeListViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/12.
//

import UIKit
import MapKit

class HomeListViewController: UIViewController {
  // MARK: - Outlets
  @IBOutlet weak var tableView: UITableView!

  // MARK: - Properties

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    setupTableView()
  }

  // MARK: - Functions
  private func setupTableView() {

    tableView.delegate = self

    tableView.dataSource = self

    tableView.register(UINib(nibName: "LandscapeCardCell", bundle: nil), forCellReuseIdentifier: "landscapeCardCell")

    tableView.estimatedRowHeight = 280

    tableView.rowHeight = UITableView.automaticDimension

    tableView.separatorStyle = .none

    tableView.reloadData()
  }

  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    if segue.identifier == "navigateToDetailVC" {

      if let indexPath = tableView.indexPathForSelectedRow {

        let detailVC = segue.destination as? DetailViewController

        //        let product = hotsDisplayData.sections[indexPath.section].sectionProducts[indexPath.row]
        //        destinationVC?.product = product
      }
    }
  }
}

extension HomeListViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    if let cell = tableView.dequeueReusableCell(
        withIdentifier: "landscapeCardCell", for: indexPath) as? LandscapeCardCell {

      cell.cafeMainImage.backgroundColor = .brown
      cell.cafeName.text = "這是一間名字很長的咖啡廳"
      cell.starsView.rating = 4.3
      cell.averageRatings.text = "4.3"
      cell.distance.text = "距離 500 m"
      cell.openHours.text = "11:00 - 20:00"
      cell.featureOne.text = "沒有網美"
      cell.featureTwo.text = "冷氣超涼讚啦"
      cell.itemOne.text = "燕麥奶拿鐵"
      cell.itemTwo.text = "冷萃咖啡"
      cell.selectionStyle = .none

      return cell
    }
    return UITableViewCell()
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "navigateToDetailVC") as? DetailViewController else { return }

    self.show(detailVC, sender: self)
  }
}

extension HomeListViewController: UITableViewDelegate {
  // Do sth
}
