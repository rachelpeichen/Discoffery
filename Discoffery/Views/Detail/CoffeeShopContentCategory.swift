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
}
