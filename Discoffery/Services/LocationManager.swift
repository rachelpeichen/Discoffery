//
//  LocationManager.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/19.
//

import Foundation
import CoreLocation

class LocationManager {

  // MARK: - Properties
  static let shared = LocationManager()

  lazy var locationManager = CLLocationManager()

  weak var delegate: CLLocationManagerDelegate?

  // MARK: - Closure for ViewModels
  // For HomeViewModel Use
  var onUserCurrentCoordinate: ((CLLocationCoordinate2D) -> Void)?

  // For MapRouteVC and more??
  var userCurrentCoordinate = CLLocationCoordinate2D() {

    didSet {
      onUserCurrentCoordinate?(userCurrentCoordinate)
    }
  }

  // MARK: - Functions
  func trackLocation(completion: (_ latitude: Double, _ longitude: Double) -> Void) {

    // Only executed if CLAuthorizationStatus = .authorizedAlways || .authorizedWhenInUse
    delegate = locationManager.delegate
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.startUpdatingLocation()
    
    guard let currentLocation = locationManager.location else { return }

    userCurrentCoordinate = currentLocation.coordinate

    let latitude = Double(currentLocation.coordinate.latitude)
    let longitude = Double(currentLocation.coordinate.longitude)

    // Pass latitude & lonitude of user's current coordinate to HomeViewModel to filter shop
    completion(latitude, longitude)
  }
}
