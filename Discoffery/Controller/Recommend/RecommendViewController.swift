//
//  RecommendViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/17.
//

import UIKit

class RecommendViewController: UIViewController {

   private enum ButtonSet: String {

      case kol = "特調冷萃"

      case coldbrew = "網美最愛"

      case dessert = "特色甜點"
    }

  private let buttonArray: [ButtonSet] = [.kol, .coldbrew, .dessert]

  @IBOutlet weak var logo: UIImageView!

  @IBOutlet weak var warning: UILabel!

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
  }

  func setupVC() {
    navigationController?.navigationBar.barTintColor = .G3
    selectionView.backgroundColor = .white
    logo.isHidden = true
    warning.isHidden = true
  }
}


extension RecommendViewController: SelectionViewDelegate {

    func didSelectedButton(_ selectionView: SelectionView, at index: Int) {

      if selectionView == selectionView {

        switch index {

        case 0:

          firstRecommendContainerView.isHidden = false
          logo.isHidden = false
          warning.isHidden = false

        case 1:

          firstRecommendContainerView.isHidden = true
          logo.isHidden = false
          warning.isHidden = false

        case 2:

          firstRecommendContainerView.isHidden = true
          logo.isHidden = false
          warning.isHidden = false

        default:

          print(0)
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

//
// class HomeViewController: UIViewController {
//
// private enum ButtonSet: String {
//
//    case map = "地圖模式"
//
//    case list = "列表模式"
//  }
//
//  // MARK: - Outlets
//  @IBOutlet weak var selectionView: SelectionView! {
//
//    didSet {
//
//      selectionView.dataSource = self
//
//      selectionView.delegate = self
//    }
//  }
//
//  @IBOutlet weak var mapContainerView: UIView!
//
//  @IBOutlet weak var listContainerView: UIView!
//
//  // MARK: - Properties
//  private let buttonArray: [ButtonSet] = [.map, .list]
//
//  // MARK: - View Life Cycle
//  override func viewDidLoad() {
//    super.viewDidLoad()
//
//    // Do any additional setup after loading the view.
//    selectionView.backgroundColor = .white
//
//    mapContainerView.isHidden = false
//
//    listContainerView.isHidden = true
//  }
//
//  // MARK: - Navigation
//  // In a storyboard-based application, you will often want to do a little preparation before navigation
//  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//      // Get the new view controller using segue.destination.
//      // Pass the selected object to the new view controller.
//      if segue.identifier == "navigateToDetailVC",
//
//         let detailViewController = segue.destination as? DetailViewController {
//
//      }
//  }
// }
//
//// MARK: - SelectionViewDataSource
//extension HomeViewController: SelectionViewDataSource {
//
//  func titleOfButton(_ selectionView: SelectionView, at index: Int) -> String {
//    return buttonArray[index].rawValue
//  }
//
//  func colorOfTitle(_ selectionView: SelectionView, at index: Int) -> UIColor? {
//    return .darkGray
//  }
//
//  func fontOfTitle(_ selectionView: SelectionView, at index: Int) -> UIFont {
//    return .systemFont(ofSize: 14)
//  }
// }
//
//  MARK: - SelectionViewDelegate
// extension HomeViewController: SelectionViewDelegate {
//
//  func didSelectedButton(_ selectionView: SelectionView, at index: Int) {
//
//    if selectionView == selectionView {
//
//      if index == 1 {
//
//        mapContainerView.isHidden = true
//
//        listContainerView.isHidden = false
//      } else {
//
//        mapContainerView.isHidden = false
//
//        listContainerView.isHidden = true
//      }
//    }
//  }
// }
