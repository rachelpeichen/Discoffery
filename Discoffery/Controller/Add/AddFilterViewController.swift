//
//  AddFilterViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/18.
//

import UIKit

class AddFilterViewController: UIViewController {

  @IBOutlet weak var cnteredFilterView: UIView!

  @IBAction func finishFilter(_ sender: UIButton) {

    dismiss(animated: true, completion: nil)
  }

  @IBOutlet weak var distanceSlider: UISlider!


  override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
