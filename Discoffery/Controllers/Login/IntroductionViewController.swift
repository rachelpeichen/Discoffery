//
//  IntroductionViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/31.
//

import UIKit

class IntroductionViewController: UIViewController {

  // MARK: - IBOutlets & IBActions
  @IBOutlet weak var bgImgView: UIImageView!

  @IBOutlet weak var dialogView: UIView!

  @IBAction func naviagteToHomeVC(_ sender: Any) {

    performSegue(withIdentifier: "navigateToHomeVC", sender: sender)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    dialogView.layoutViewWithShadow()
  }
}
