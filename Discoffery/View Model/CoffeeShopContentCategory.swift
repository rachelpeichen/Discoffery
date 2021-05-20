//
//  ShopContentCategory.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/17.
//

import Foundation

enum CoffeeShopContentCategory {

  case images

  case description

  case recommend

  case feature

  case route

  case writeReview

  func identifier() -> String {

    switch self {

    case .images: return String(describing: ShopImagesCell.self)

    case .description: return String(describing: ShopDescriptionCell.self)

    case .recommend, .feature: return String(describing: ShopFeatureCell.self)

    case .route: return String(describing: ShopRouteCell.self)

    case .writeReview: return String(describing: WriteReviewCell.self)
    }
  }

//  func cellForIndexPath(_ indexPath: IndexPath, tableView: UITableView, data: CoffeeShop) -> UITableViewCell {
//
//    let cell = tableView.dequeueReusableCell(withIdentifier: identifier(), for: indexPath)
//
//    guard let basicCell = cell as? ShopDetailBasicCell else { return cell }
//
//    switch self {
//
//    case .description:
//
//      basicCell.layoutCell(product: data)
//
//    case .recommend:
//
//      basicCell.layoutCell(category: rawValue, content: "")
//
//    case .feature:
//
//      basicCell.layoutCell(category: rawValue, content: "")
//
//    case .route:
//
//      basicCell.layoutCell(category: rawValue, content: "")
//
//    case .writeReview:
//
//      basicCell.layoutCell(category: rawValue, content: "")
//    }
//    return basicCell
//  }
}
