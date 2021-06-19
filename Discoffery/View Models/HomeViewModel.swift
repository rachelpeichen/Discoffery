//
//  HomeMapView.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/13.
//

import Foundation
import CoreLocation
import MapKit

protocol HomeViewModelDelegate: AnyObject {

  func setUpMapView()
}

class HomeViewModel {

  // MARK: - Closures for HomeMapVC & HomeListVC
  // HomeMapVC
  var onShopsDataForMap: (([CoffeeShop]) -> Void)? // OK

  var onShopsAnnotationsForMap: (([MKPointAnnotation]) -> Void)? // OK

  var onFeatureDicForMap: (([String: [Feature]]) -> Void)?

  var onRecommendItemsDicForMap: (([String: [RecommendItem]]) -> Void)?

  // HomeListVC
  var onShopsDataForList: (([CoffeeShop]) -> Void)?

  // MARK: - Properties
  weak var delegate: HomeViewModelDelegate?

  var shopsData: [CoffeeShop] = [] {

    didSet {

      onShopsDataForMap?(shopsData)
      markAnnotationForShops(shops: shopsData)
    }
  }

  var featureDic: [String: [Feature]] = [:]

  var recommendItemsDic: [String: [RecommendItem]] = [:]

  var userCurrentCoordinate: CLLocationCoordinate2D?

  // MARK: - HomeMapVC & HomeListVC Shared Functions
  // 1
  func getUserCurrentCoordinate() {

    LocationManager.shared.onUserCurrentCoordinate = { coordinate in

      self.userCurrentCoordinate = coordinate
    }
  }

  // 2
  func fetchShopsAroundUser(distance: Double = 1000) {

    LocationManager.shared.trackLocation { latitude, longitude in

      filterShopWithinDistance(latitude: latitude, longitude: longitude, distanceInMeters: distance)
    }
  }

  // 3
  func filterShopWithinDistance(latitude: Double, longitude: Double, distanceInMeters: Double) {

    // 3-1
    CoffeeShopManager.shared.fetchShopWithinLatitude(latitude: latitude,
                                                     distance: distanceInMeters) { [weak self] result in

      switch result {

      case .success(let filteredShops):
        // 3-2
        self?.filterShopWithinLongitude(shopFilteredByLat: filteredShops,
                                        latitude: latitude,
                                        longitude: longitude,
                                        distance: distanceInMeters)
      case .failure(let error):
        print("filterShopWithinLatitude.error: \(error)")
      }
    }
  }

  // 3-2
  func filterShopWithinLongitude(shopFilteredByLat: [CoffeeShop], latitude: Double, longitude: Double, distance: Double) {

    // The number of meters per degree of lonitude (roughly)
    let metersPerLonDegree = (Double.pi / 180) * 6371000 * cos(latitude / 180)

    let lowerLon = longitude - (distance / metersPerLonDegree)
    let upperLon = longitude + (distance / metersPerLonDegree)

    shopsData = shopFilteredByLat.filter { $0.longitude >= lowerLon && $0.longitude <= upperLon }
  }

  // 4: 計算跟以下fetch還不知道放哪邊好
  func calDistanceBetweenUserAndShop() {

    for index in 0..<shopsData.count {

      guard let coordinate = userCurrentCoordinate else { return }

      let distance = calDistanceBetweenTwoLocations(location1Lat: coordinate.latitude,
                                                    location1Lon: coordinate.longitude,
                                                    location2Lat: shopsData[index].latitude,
                                                    location2Lon: shopsData[index].longitude)
      shopsData[index].cheap = distance
    }
  }

  func calDistanceBetweenTwoLocations(location1Lat: Double, location1Lon: Double, location2Lat: Double, location2Lon: Double) -> Double {

    // Use Haversine Formula to calculate the distance in meter between two locations
    // φ is latitude, λ is longitude, R is earth’s radius (mean radius = 6,371km)
    let lat1 = location1Lat
    let lat2 = location2Lat
    let lon1 = location1Lon
    let lon2 = location2Lon
    let earthRadius = 6371000.0

    // swiftlint:disable identifier_name
    let φ1 = lat1 * Double.pi / 180 // φ, λ in radians
    let φ2 = lat2 * Double.pi / 180
    let Δφ = (lat2 - lat1) * Double.pi / 180
    let Δλ = (lon2 - lon1) * Double.pi / 180

    let parameterA = sin(Δφ / 2) * sin(Δφ / 2) + cos(φ1) * cos(φ2) * sin(Δλ / 2) * sin(Δλ / 2)
    let parameterC = 2 * atan2(sqrt(parameterA), sqrt(1 - parameterA))
    let distance = earthRadius * parameterC

    return distance
  }

  // 5
  func fetchFeatureForShopsData(shopsData: [CoffeeShop]) {

    for index in 0..<shopsData.count {

      fetchFeatureForShop(shop: shopsData[index])
    }
    onFeatureDicForMap?(featureDic)
  }

  func fetchFeatureForShop(shop: CoffeeShop) {

    FeatureManager.shared.fetchFeatureForShop(shop: shop) { [weak self] result in

      switch result {

      case .success(let getFeature):
        self?.featureDic[shop.id] = getFeature

      case .failure(let error):
        print("fetchFeatureForShop.error:\(error)")
      }
    }
  }

  // 6
  func fetchRecommendItemForShopsData(shopsData: [CoffeeShop]) {

    for index in 0..<shopsData.count {

      fetchRecommendItemForShop(shop: shopsData[index])
    }
    onRecommendItemsDicForMap?(recommendItemsDic)
  }

  func fetchRecommendItemForShop(shop: CoffeeShop) {

    RecommendItemManager.shared.fetchRecommendItemForShop(shop: shop) { result in

      switch result {

      case .success(let getItems):
        self.recommendItemsDic[shop.id] = getItems

      case .failure(let error):
        print("fetchRecommendItemForShop.error\(error)")
      }
    }
  }

  // MARK: - Functions Only For HomeMapVC Use
  func markAnnotationForShops(shops: [CoffeeShop]) {

    var shopAnnotations: [MKPointAnnotation] = []

    for index in 0..<shopsData.count {

      let shopAnnotation = MKPointAnnotation()
      shopAnnotation.coordinate.longitude = shopsData[index].longitude
      shopAnnotation.coordinate.latitude = shopsData[index].latitude
      shopAnnotation.title = shopsData[index].name
      shopAnnotations.append(shopAnnotation)
    }
    self.onShopsAnnotationsForMap?(shopAnnotations)
  }
}
