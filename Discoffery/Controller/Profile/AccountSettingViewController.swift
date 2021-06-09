//
//  AccountSettingViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/6/8.
//

import UIKit

class AccountSettingViewController: UIViewController {

  // MARK: - Properties
  var userViewModel = UserViewModel()

  var blockList: [String] = []

  // MARK: - Outlets
  @IBOutlet weak var tableView: UITableView!

  override func viewWillAppear(_ animated: Bool) {
    
    super.viewWillAppear(true)

    userViewModel.fetchBlockList(user: UserManager.shared.user)

    userViewModel.onBlockList = { result in

      self.blockList = result

      self.setupTableView()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    navigationController?.navigationBar.barTintColor = .G3
    navigationController?.navigationBar.tintColor = .G1
  }

  // MARK: - Functions
  private func setupTableView() {

    tableView.delegate = self

    tableView.dataSource = self

    tableView.estimatedRowHeight = 80

    tableView.rowHeight = UITableView.automaticDimension

    tableView.separatorStyle = .none

    tableView.reloadData()
  }

  func unBlockUser(unblockName: String) {

    userViewModel.updateBlockList(user: UserManager.shared.user, unBlockName: unblockName)
  }
}

extension AccountSettingViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    return blockList.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    if let cell = tableView.dequeueReusableCell(withIdentifier: BlockListTableViewCell.identifier, for: indexPath) as? BlockListTableViewCell {

      cell.layoutBlockListCell(user: blockList[indexPath.row])

      cell.selectionStyle = .none

      return cell
    }
    return BlockListTableViewCell()
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    unBlockUser(unblockName: blockList[indexPath.row])

   blockList.remove(at: (indexPath.row))

   tableView.reloadData()
  }
}

extension AccountSettingViewController: UITableViewDelegate {
}
