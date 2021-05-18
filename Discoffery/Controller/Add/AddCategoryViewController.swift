//
//  AddCategoryViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/18.
//

import UIKit
import SnapKit
import SwiftEntryKit

class AddCategoryViewController: UIViewController {

  let addCategoryView = UIView()

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view
    test()
  }

  func setUpAddCategoryView() {

    view.addSubview(addCategoryView)

    addCategoryView.snp.makeConstraints { maker in
      maker.size.equalTo(CGSize(width: 200, height: 200))
      maker.center.equalTo(view)
    }
    addCategoryView.backgroundColor = .lightGray
  }

  func test() {

    // Generate top floating entry and set some properties
    var attributes = EKAttributes.topFloat
    attributes.entryBackground = .gradient(gradient: .init(colors: [.red, .green], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
    attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
    attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
    attributes.statusBar = .dark
    attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
    attributes.positionConstraints.maxSize = .init(width: .constant(value: 200), height: .intrinsic)

    let title = EKProperty.LabelContent(text: "YOOOOOO", style: .init(font: .systemFont(ofSize: 14), color: .black))
    let description = EKProperty.LabelContent(text:"YOOOOOO", style: .init(font: .systemFont(ofSize: 14), color: .blue))
    let image = EKProperty.ImageContent(image: UIImage(named: "mock_1")!, size: CGSize(width: 35, height: 35))
    let simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
    let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)

    let contentView = EKNotificationMessageView(with: notificationMessage)
    SwiftEntryKit.display(entry: contentView, using: attributes)
  }
}
