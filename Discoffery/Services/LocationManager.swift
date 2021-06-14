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

  var onCurrentCoordinate: ((CLLocationCoordinate2D) -> Void)?

  var currentCoordinate = CLLocationCoordinate2D() // Save this for MapRouteVC

  // MARK: - Functions
  func trackLocation(completion: (_ latitude: Double, _ longitude: Double) -> Void) {

    // Only executed if CLAuthorizationStatus = .authorizedAlways || .authorizedWhenInUse
    delegate = locationManager.delegate

    locationManager.desiredAccuracy = kCLLocationAccuracyBest

    locationManager.startUpdatingLocation()
    
    guard let currentLocation = locationManager.location else { return }

    // Pass to HomeMapViewController for drawing map
    onCurrentCoordinate?(currentLocation.coordinate)

    let latitude = Double(currentLocation.coordinate.latitude)
    
    let longitude = Double(currentLocation.coordinate.longitude)

    currentCoordinate.latitude = latitude

    currentCoordinate.longitude = longitude

    // Pass to HomeMapViewModel for fetching data on Firebase
    completion(latitude, longitude)
  }
}
