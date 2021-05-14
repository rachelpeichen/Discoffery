//
//  LocationGeocoder.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/14.
//

import Foundation
import CoreLocation

class LocationGeocoder {

  private lazy var geocoder = CLGeocoder()

  // Convert a place address to a location
  func geocode(addressString: String, callback: @escaping ([Location]) -> Void) {

    geocoder.geocodeAddressString(addressString) { placemarks, error in

      var locations: [Location] = []

      if let error = error {

        print("Geocoding error: (\(error))")
      } else {

        if let placemarks = placemarks {

          locations = placemarks.compactMap { placemark -> Location? in

            guard let location = placemark.location else { return nil }

            return Location(
              latitude: location.coordinate.latitude,
              longitude: location.coordinate.longitude
            )
          }
        }
      }
      callback(locations)
    }
  }
}
