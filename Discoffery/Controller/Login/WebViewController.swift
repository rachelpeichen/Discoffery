//
//  WebViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/6/7.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

  @IBOutlet var webView: WKWebView!

  let targetURL = "https://www.privacypolicies.com/live/b614706d-d87d-46ae-8673-2564316a309c"

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.

    navigationItem.largeTitleDisplayMode = .never

    if let url = URL(string: targetURL) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
  }
}
