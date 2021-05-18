//
//  ProfileViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/17.
//

import UIKit

class ProfileViewController: UIViewController {

  // MARK: Outlets
  @IBOutlet weak var profileImage: UIImageView!

  @IBOutlet weak var userID: UILabel!

  @IBOutlet weak var tableView: UITableView!

  // MARK: Properties
  var titleForSettingButtons: [String] = ["🍌我發表的評價", "🍎我的寄杯", "🍐我的儲值卡", "🍉帳號設定", "🍒常見問題", "🍈隱私權政策", "🥝聯絡我們", "🍑關於Discoffery"]

  // MARK: Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    setUpProfileImageLayout()

  }

  // MARK: Functions
  private func setUpProfileImageLayout() {

    profileImage.clipsToBounds = true

    profileImage.layer.cornerRadius = 40
  }

  private func setUpProfileCellLayout() {

    tableView.reloadData()
  }
}

extension ProfileViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return titleForSettingButtons.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as? ProfileCell

    cell?.settingButton.setTitle(titleForSettingButtons[indexPath.row], for: .normal)

    tableView.separatorStyle = .none

    return cell ?? UITableViewCell()
  }
}

extension ProfileViewController: UITableViewDelegate {

}
