//
//  HomeMapView.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/13.
//

import Foundation
import CoreLocation
import MapKit

class HomeMapViewModel {

  var bindHomeMapViewModelToController: (() -> Void)?

  var onPlacemarkTransformed: (([MKPointAnnotation]) -> Void)?

  var coffeeShopsData: [CoffeeShop]? {

    didSet {

      self.bindHomeMapViewModelToController?()
    }
  }

  var shopPlacemarks: [MKPointAnnotation]? {
    didSet {

      self.onPlacemarkTransformed?(shopPlacemarks!)
    }
  }

  func fetchData() {

    APIManager.shared.request { result in

      self.coffeeShopsData = result
    }
  }

  func transformAddressToPlacemark(shops: [CoffeeShop]) {

    // do a lot
    // change shopAnnotations
  }
}
