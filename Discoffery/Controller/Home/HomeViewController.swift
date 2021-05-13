//
//  ViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/12.
//

import UIKit

class HomeViewController: UIViewController {

  private enum ButtonSet: String {

    case map = "地圖模式"

    case list = "列表模式"
  }

  // MARK: - Outlets
  @IBOutlet weak var selectionView: SelectionView! {

    didSet {

      selectionView.dataSource = self

      selectionView.delegate = self
    }
  }

  @IBOutlet weak var mapContainerView: UIView!

  @IBOutlet weak var listContainerView: UIView!

  // MARK: - Properties
  private let buttonArray: [ButtonSet] = [.map, .list]

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.

    selectionView.backgroundColor = .white

    mapContainerView.isHidden = false

    listContainerView.isHidden = true
  }
}

// MARK: - Conform SelectionView protocol
extension HomeViewController: SelectionViewDataSource {

  func titleOfButton(_ selectionView: SelectionView, at index: Int) -> String {
    return buttonArray[index].rawValue
  }

  func colorOfTitle(_ selectionView: SelectionView, at index: Int) -> UIColor? {
    return .darkGray
  }

  func fontOfTitle(_ selectionView: SelectionView, at index: Int) -> UIFont {
    return .systemFont(ofSize: 14)
  }
}

extension HomeViewController: SelectionViewDelegate {

  func didSelectedButton(_ selectionView: SelectionView, at index: Int) {

    if selectionView == selectionView {

      if index == 1 {

        mapContainerView.isHidden = true

        listContainerView.isHidden = false
      } else {

        mapContainerView.isHidden = false

        listContainerView.isHidden = true
      }
    }
  }
}
