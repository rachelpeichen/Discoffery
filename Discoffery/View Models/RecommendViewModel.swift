//
//  RecommendViewModel.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/6/8.
//

import Foundation
import CoreLocation

class RecommendViewModel {

  // MARK: - Closures For Notifying Recommend VC
  var onRecommendShopAroundUser: (([CoffeeShop]) -> Void)?

  var onShopRecommendItems: (([RecommendItem]) -> Void)?

  // MARK: - Properties
  var recommendShopAroundUser: [CoffeeShop] = [] {

    didSet {

      onRecommendShopAroundUser?(recommendShopAroundUser)
    }
  }

  var userCurrentCoordinate: CLLocationCoordinate2D?

  // MARK: - Distance Between Shop & User Related Functions
  func getShopAroundUser(distance: Double = 1500) {

    LocationManager.shared.trackLocation { latitude, longitude in

      filterShopWithinDistance(latitude: latitude, longitude: longitude, distanceInMeters: distance)

      self.userCurrentCoordinate?.latitude = latitude
      self.userCurrentCoordinate?.longitude = longitude
    }
  }

  func filterShopWithinDistance(latitude: Double, longitude: Double, distanceInMeters: Double) {

    // Find all shops within input meters within user's current location; default is 2000 m for getting more data to filter
    CoffeeShopManager.shared.fetchShopWithinLatitude(latitude: latitude,
                                                     distance: distanceInMeters) { [weak self] result in

      switch result {

      case .success(let filteredShops):

        self?.filterShopWithinLongitude(
          shopFilteredByLat: filteredShops,
          latitude: latitude,
          longitude: longitude,
          distance: distanceInMeters)

      case .failure(let error):
        print("filterShopWithinLatitude.failure: \(error)")
      }
    }
  }

  func filterShopWithinLongitude(shopFilteredByLat: [CoffeeShop], latitude: Double, longitude: Double, distance: Double) {

    // The number of meters per degree of lonitude (roughly)
    let metersPerLonDegree = (Double.pi / 180) * 6371000 * cos(latitude / 180)
    let lowerLon = longitude - (distance / metersPerLonDegree)
    let upperLon = longitude + (distance / metersPerLonDegree)
    recommendShopAroundUser = shopFilteredByLat.filter { $0.longitude >= lowerLon && $0.longitude <= upperLon }
  }

  func fetchRecommendItemsForShop(shop: CoffeeShop) {

    RecommendItemManager.shared.fetchRecommendItemForShop(shop: shop) { result in

      switch result {

      case .success(let items):
        self.onShopRecommendItems?(items)

      case .failure(let error):
        print("fetchFeatureForShop.failure: \(error)")
      }
    }
  }
}
