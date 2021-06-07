//
//  ProfileViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/17.
//

import UIKit

class ProfileViewController: UIViewController {

  // MARK: - Outlets
  @IBOutlet weak var profileImage: UIImageView!

  @IBOutlet weak var userName: UILabel!

  @IBOutlet weak var userEmail: UILabel!

  @IBOutlet weak var userLoginTime: UILabel!

  @IBOutlet weak var tableView: UITableView!

  // MARK: - Properties
  var titleForSettingLabel: [String] = ["我發表的評價", "我新增的咖啡廳資訊", "帳號設定", "常見問題", "聯絡開發者", "關於Discoffery", "贊助熬夜的開發者喝咖啡"]

  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    setUpProfileVCLayout()
  }

  // MARK: - Functions
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

    return titleForSettingLabel.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    if let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as? ProfileCell {

      cell.settingLabel.text = titleForSettingLabel[indexPath.row]

      tableView.separatorStyle = .none

      return cell
    }
    return ProfileCell()
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    switch indexPath.row {

    case 0:
      print(0)

    case 1:
      print(1)

    case 2:

      performSegue(withIdentifier: "naviagetToAccountSettingVC", sender: indexPath.row)

    default:
      print("default")
    }
  }
}

extension ProfileViewController: UITableViewDelegate {

}
