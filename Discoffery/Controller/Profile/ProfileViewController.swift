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

  @IBOutlet weak var userName: UILabel!

  @IBOutlet weak var userEmail: UILabel!

  @IBOutlet weak var userLoginTime: UILabel!

  @IBOutlet weak var tableView: UITableView!

  // MARK: Properties
  var titleForSettingButtons: [String] = ["我發表的評價", "我新增的咖啡廳資訊", "帳號設定", "常見問題", "隱私權政策", "聯絡我們", "關於Discoffery"]

  // MARK: Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    setUpProfileVCLayout()
  }

  // MARK: Functions
  private func setUpProfileVCLayout() {
    
    navigationController?.navigationBar.barTintColor = UIColor.init(named: "G3")

    profileImage.clipsToBounds = true

    profileImage.layer.cornerRadius = 40

    userName.text = UserManager.shared.user.name

    userEmail.text = UserManager.shared.user.email

    userLoginTime.text = Date.dateFormatter.string(from: Date.init(milliseconds: UserManager.shared.user.createdTime))

    tableView.delegate = self

    tableView.dataSource = self
    
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
