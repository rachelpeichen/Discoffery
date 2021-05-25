//
//  CollectionViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/17.
//

import UIKit

class CollectionViewController: UIViewController {

  // MARK: Outlets
  @IBOutlet weak var addNewCategory: UIBarButtonItem!

  @IBOutlet weak var tableView: UITableView!

  // MARK: Properties

  var categories: [String] = ["預設分類1", " 用戶分類1", "用戶分類2"]

  // MARK: Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    setupTableView()

    navigationController?.navigationBar.barTintColor = UIColor.init(named: "G3")
  }

  // MARK: Functions
  private func setupTableView() {

    tableView.register(UINib(nibName: "CollectionCell", bundle: nil), forCellReuseIdentifier: "collectionCell")

    tableView.estimatedRowHeight = 300

    tableView.rowHeight = UITableView.automaticDimension

    tableView.separatorStyle = .none

    tableView.reloadData()
  }
}

extension CollectionViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    return 3
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    if let cell = tableView.dequeueReusableCell(withIdentifier: "collectionCell", for: indexPath) as? CollectionCell {

      cell.category.text = categories[indexPath.row]

      return cell
    }
    return CollectionCell()
  }
}

extension CollectionViewController: UITableViewDelegate {
}
