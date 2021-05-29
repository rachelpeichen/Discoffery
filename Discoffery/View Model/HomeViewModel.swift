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

  var onShopsAnnotations: (([MKPointAnnotation]) -> Void)? // Pass to HomeMapVC
  
  var getShopsData: (([CoffeeShop]) -> Void)? // Pass to HomeMapVC & HomeListVC

  var shopsData = [CoffeeShop]() {

    didSet {

      markAnnotationForShops(shops: shopsData)

      getShopsData?(shopsData)
    }
  }

  var distanceBetweenUserAndShop: Double?

  // MARK: - Functions
  func getShopAroundUser() {

    LocationManager.shared.trackLocation { latitude, longitude in

      filterShopWithinDistance(latitude: latitude, longitude: longitude)
    }
  }

  func filterShopWithinDistance(latitude: Double, longitude: Double, distanceInMeters: Double = 500) {

    // Find all shops within input meters within user's current location; default is 500 m
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

      case .success(let newShop):

        print("🥴fetchShopSelectedOnMap Success")

      case .failure(let error):

        print("publishNewShop.failure\(error)")
      }
    })
  }
}
