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

  // MARK: - Properties
  weak var delegate: HomeViewModelDelegate?

  var onShopsAnnotations: (([MKPointAnnotation]) -> Void)? // Only HomeMapVC use this
  
  var onShopsData: (([CoffeeShop]) -> Void)? // Only HomeListVC use this

  var onFetchSavedShopsForAllCategory: (() -> Void)?

  var shopsData: [CoffeeShop] = [] {

    didSet {

      markAnnotationForShops(shops: shopsData)

      onShopsData?(shopsData)
    }
  }

  var onUserCurrentCoordinate: ((CLLocationCoordinate2D) -> Void)?  // Only HomeMapVC use this?????

  var userCurrentCoordinate: CLLocationCoordinate2D? {

    didSet {

      if let userCurrentCoordinate = userCurrentCoordinate {

        self.onUserCurrentCoordinate?(userCurrentCoordinate)
      }
    }
  }

  var savedShopsForAllCategory: [UserSavedShops] = [] {

    didSet {

      onFetchSavedShopsForAllCategory?()
    }
  }

  // MARK: - Map related functions
  func getShopAroundUser(distance: Double = 1000) {

    LocationManager.shared.trackLocation { latitude, longitude in

      filterShopWithinDistance(latitude: latitude, longitude: longitude, distanceInMeters: distance)
    }
  }

  func filterShopWithinDistance(latitude: Double, longitude: Double, distanceInMeters: Double) {

    // Find all shops within input meters within user's current location; default is 1000 m
    CoffeeShopManager.shared.fetchShopWithinLatitude(latitude: latitude, distance: distanceInMeters) { [weak self] result in

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

    // The number of meters per degree of lonitude (roughly) 換算 1 degrees 的經度 ~ 110122 m
    let metersPerLonDegree = (Double.pi / 180) * 6371000 * cos(latitude / 180)

    let lowerLon = longitude - (distance / metersPerLonDegree) // 經度下限

    let upperLon = longitude + (distance / metersPerLonDegree) // 經度上限

    shopsData = shopFilteredByLat.filter { $0.longitude >= lowerLon && $0.longitude <= upperLon }
  }

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

      case .success(let _):

        print("🥴fetchShopSelectedOnMap Success")

      case .failure(let error):

        print("publishNewShop.failure\(error)")
      }
    })
  }

  // MARK: check if user has saved the shop
  func fetchSavedShopsForAllCategory(user: User) {

    UserManager.shared.fetchSavedShopsForAllCategory(user: user) { result in

      switch result {

      case .success(let savedShopDocs):

        self.savedShopsForAllCategory = savedShopDocs

      case .failure(let error):

        print("fetchSavedShopsForAllCategory.failure: \(error)")
      }
    }
  }
}
