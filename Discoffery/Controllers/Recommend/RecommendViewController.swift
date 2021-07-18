//
//  RecommendViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/17.
//

import UIKit

class RecommendViewController: UIViewController {

  // MARK: - Properties
  private enum ButtonSet: String {
    case kol = "特調冷萃"
    case coldbrew = "網美最愛"
    case dessert = "特色甜點"
  }

  private let buttonArray: [ButtonSet] = [.kol, .coldbrew, .dessert]

  // MARK: - IBOutlets
  @IBOutlet weak var logo: UIImageView!
  @IBOutlet weak var announce: UILabel!
  @IBOutlet weak var firstRecommendContainerView: UIView!

  @IBOutlet weak var selectionView: SelectionView! {
    didSet {
      selectionView.dataSource = self
      selectionView.delegate = self
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    setupVC()
    logo.isHidden = true
    announce.isHidden = true
  }

  // MARK: - Private Functions
  private func setupVC() {
    navigationController?.navigationBar.barTintColor = .G3

    navigationController?.navigationBar.tintColor = .G1

    selectionView.backgroundColor = .white
  }
}

extension RecommendViewController: SelectionViewDelegate {

  func didSelectedButton(_ selectionView: SelectionView, at index: Int) {

    if selectionView == selectionView {

      switch index {

      case 0:

        firstRecommendContainerView.isHidden = false
        logo.isHidden = true
        announce.isHidden = true

      case 1:

        firstRecommendContainerView.isHidden = true
        logo.isHidden = false
        announce.isHidden = false

      case 2:

        firstRecommendContainerView.isHidden = true
        logo.isHidden = false
        announce.isHidden = false

      default:

        print("Nothing happens")
      }
    }
  }
}

extension RecommendViewController: SelectionViewDataSource {

  func numberOfButtons(in selectionView: SelectionView) -> Int {
    return 3
  }

  func titleOfButton(_ selectionView: SelectionView, at index: Int) -> String {
    buttonArray[index].rawValue
  }
}
