//
//  ViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/12.
//

import UIKit

class HomeViewController: UIViewController {

  // MARK: - Properties
  var sharedHomeViewModel = HomeViewModel()

  // MARK: - IBOutlets & IBActions
  @IBOutlet weak var mapContainerView: UIView!
  @IBOutlet weak var listContainerView: UIView!

  @IBAction func changeLayout(_ sender: UIButton) {

    if listContainerView.isHidden == true {

      listContainerView.isHidden = false
      mapContainerView.isHidden  = true

      let listIconConfig = UIImage.SymbolConfiguration(scale: .large)
      let listIcon       = UIImage(systemName: "list.dash", withConfiguration: listIconConfig)

      sender.setImage(listIcon, for: .normal)

    } else if listContainerView.isHidden == false {

      listContainerView.isHidden = true
      mapContainerView.isHidden  = false

      let mapIconConfig = UIImage.SymbolConfiguration(scale: .large)
      let mapIcon       = UIImage(systemName: "map", withConfiguration: mapIconConfig)
      
      sender.setImage(mapIcon, for: .normal)
    }
  }

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.

    mapContainerView.isHidden = false
    listContainerView.isHidden = true
  }

  // MARK: - Functions
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    // mapVC & listVC can both use the same model and get data at the same time
    if let mapVC = segue.destination as? HomeMapViewController {

      mapVC.homeViewModel = self.sharedHomeViewModel
    }

    if let listVC = segue.destination as? HomeListViewController {

      listVC.homeViewModel = self.sharedHomeViewModel
    }
  }
}
