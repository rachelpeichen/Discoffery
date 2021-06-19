//
//  ProfileViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/17.
//

import UIKit
import Kingfisher

class ProfileViewController: UIViewController {
  
  // MARK: - Properties
  var userViewModel = UserViewModel()

  var titleLabel: [String] = ["我發表的評價", "我新增的咖啡廳資訊", "封鎖用戶名單", "帳號設定"]

  override func viewWillAppear(_ animated: Bool) {

    super.viewWillAppear(true)

    userViewModel.watchUser()

    userViewModel.onWatchUser = { result in

      UserManager.shared.user.email = result.email

      UserManager.shared.user.name = result.name

      self.userNameLabel.text = result.name

      self.userEmailLabel.text = result.email

      self.profileImg.loadImage(result.profileImg)
    }
  }

  // MARK: - Outlets
  @IBOutlet weak var profileImg: UIImageView!

  @IBOutlet weak var userNameLabel: UILabel!

  @IBOutlet weak var userEmailLabel: UILabel!

  @IBOutlet weak var tableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    setUpProfileVCLayout()
  }

  // MARK: - Functions
  private func setUpProfileVCLayout() {
    
    navigationController?.navigationBar.barTintColor = .G3

    navigationController?.navigationBar.tintColor = .G1

    profileImg.clipsToBounds = true

    profileImg.layer.cornerRadius = 40

    userNameLabel.text = UserDefaults.standard.object(forKey: "uid") as? String

    tableView.delegate = self

    tableView.dataSource = self
    
    tableView.reloadData()
  }
}

extension ProfileViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    return titleLabel.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    if let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as? ProfileCell {

      cell.settingLabel.text = titleLabel[indexPath.row]

      tableView.separatorStyle = .none

      return cell
    }
    return ProfileCell()
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    switch indexPath.row {

    case 0:
      performSegue(withIdentifier: "naviateToUserReviewVC", sender: indexPath.row)

    case 1:
      performSegue(withIdentifier: "navigateToPostVC", sender: indexPath.row)

    case 2:
      performSegue(withIdentifier: "naviagetToBlockVC", sender: indexPath.row)

    case 3:
      performSegue(withIdentifier: "navigateToSettingVC", sender: indexPath.row)

    default:
      print("Nothing happens")
    }
  }
}

extension ProfileViewController: UITableViewDelegate {
}
