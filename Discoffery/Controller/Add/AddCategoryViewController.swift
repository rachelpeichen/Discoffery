//
//  AddCategoryViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/18.
//

import UIKit
import SnapKit

class AddCategoryViewController: UIViewController {

  let addCategoryView = UIView()

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view
  }

  func setUpAddCategoryView() {

    view.addSubview(addCategoryView)

    addCategoryView.snp.makeConstraints { maker in
      maker.size.equalTo(CGSize(width: 200, height: 200))
      maker.center.equalTo(view)
    }
    addCategoryView.backgroundColor = .lightGray
  }
}
