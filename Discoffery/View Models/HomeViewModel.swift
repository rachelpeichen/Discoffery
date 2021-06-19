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
  var onShopsAnnotations: (([MKPointAnnotation]) -> Void)? // Only HomeMapVC use this

  var onShopsData: (([CoffeeShop]) -> Void)? // Only HomeListVC use this

  var onUserCurrentCoordinate: ((CLLocationCoordinate2D) -> Void)?  // Only HomeMapVC use this?????

  // MARK: - Properties
  weak var delegate: HomeViewModelDelegate?

  var shopsData: [CoffeeShop] = [] {

    didSet {
      onShopsData?(shopsData)
      markAnnotationForShops(shops: shopsData)
    }
  }

  var userCurrentCoordinate: CLLocationCoordinate2D? {

    didSet {

      if let userCurrentCoordinate = userCurrentCoordinate {
        onUserCurrentCoordinate?(userCurrentCoordinate)
      }
    }
  }
  // MARK: - Map Related Functions
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

  // MARK: - Functions For HomeMapVC
  func markAnnotationForShops(shops: [CoffeeShop]) {

    var shopAnnotations: [MKPointAnnotation] = []

    for index in 0..<shopsData.count {

      let shopAnnotation = MKPointAnnotation()
      shopAnnotation.coordinate.longitude = shopsData[index].longitude
      shopAnnotation.coordinate.latitude = shopsData[index].latitude
      shopAnnotation.title = shopsData[index].name
      shopAnnotations.append(shopAnnotation)
    }
    self.onShopsAnnotations?(shopAnnotations)
  }

  func fetchShopSelectedOnMap(name: String) {

    CoffeeShopManager.shared.fetchShopSelectedOnMap(name: name, completion: { result in

      switch result {

      case .success:
        print("🥴fetchShopSelectedOnMap Success")

      case .failure(let error):
        print("publishNewShop.failure\(error)")
      }
    })
  }
}
