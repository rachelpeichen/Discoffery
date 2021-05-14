//
//  Map.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/13.
//

import Foundation
import CoreLocation

struct Location {

  let latitude: Double

  let longitude: Double

  var location: CLLocation {
    return CLLocation(latitude: latitude, longitude: longitude)
  }
}
