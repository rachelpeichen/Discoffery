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

  var currentLocation: CLLocation?

  var closure: ((CLLocationCoordinate2D) -> Void)?

  // MARK: - Functions
  func trackLocation(completion: (_ latitude: Double, _ longitude: Double) -> Void) {
    // Only executed if CLAuthorizationStatus = .authorizedAlways || .authorizedWhenInUse

    delegate = locationManager.delegate

    locationManager.desiredAccuracy = kCLLocationAccuracyBest

    locationManager.startUpdatingLocation()
    
    guard let currentLocation = locationManager.location else { return }

    // Pass to HomeMapViewController
    closure?(currentLocation.coordinate)

    let latitude = Double(currentLocation.coordinate.latitude)

    let longitude = Double(currentLocation.coordinate.longitude)

    // Pass to HomeMapViewModel
    completion(latitude, longitude)
  }
}
