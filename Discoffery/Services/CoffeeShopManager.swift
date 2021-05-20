//
//  CoffeeShopManager.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/14.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import CoreLocation
import GeoFire

enum FirebaseError: Error {
  case documentError
}

enum OtherError: Error {
  case youKnowNothingError(String)
}

class CoffeeShopManager {

  // MARK: - Properties
  static let shared = CoffeeShopManager()

  lazy var database = Firestore.firestore()

  let userLocation = CLLocationCoordinate2D(latitude: 25.024368286132812, longitude: 121.5294315869483) // 應該要var in HomeMapViewModel

  // MARK: - Functions
  func publishShop(shop: inout CoffeeShop, completion: @escaping (Result<String, Error>) -> Void) {

    //  Add a new collection to Firebase
    let docRef = database.collection("shops").document()

    shop.id = docRef.documentID

    docRef.setData(shop.toDict) { error in

      if let error = error {
        completion(.failure(error))
        
      } else {
        completion(.success("Success"))
      }
    }
  }

  func updateShopGeoPoint(shop: inout CoffeeShop, completion: @escaping (Result<String, Error>) -> Void) {

    // Update location from original String to GeoPoint
    let location = GeoPoint(latitude: Double(shop.latitude)!, longitude: Double(shop.longitude)!)

    let updateField: [String: Any] = ["location": location]

    let updatedDocRef = database.collection("shops").document(shop.id)

    updatedDocRef.updateData(updateField) { error in

      if let error = error {
        completion(.failure(error))

      } else {
        completion(.success("success"))
      }
    }
  }

  func fetchShopWithinDistance(latitude: Double, longitude: Double, distance: Double = 500) {

    // Find all shops within input meter of user's current location; default 500 m

    // 1 meter of lat and lng in degrees (roughly)
    let lat = (Double.pi / 180) * 6371000.0

    let lon = (Double.pi / 180) * 6371000.0 * cos(latitude/180)

    let lowerLat = latitude - (lat * distance)
    let lowerLon = longitude - (lon * distance)

    let greaterLat = latitude + (lat * distance)
    let greaterLon = longitude + (lon * distance)

    let lesserGeopoint = GeoPoint(latitude: lowerLat, longitude: lowerLon)
    let greaterGeopoint = GeoPoint(latitude: greaterLat, longitude: greaterLon)

    let docRef = Firestore.firestore().collection("yo")

    let query = docRef.whereField("location", isGreaterThan: lesserGeopoint).whereField("location", isLessThan: greaterGeopoint)

    query.getDocuments { snapshot, error in
      if let error = error {
        print("Error getting documents: \(error)")
      } else {
        for document in snapshot!.documents {
          print("\(document.documentID) => \(document.data())")
        }
      }
    }
  }

  func calDistanceBetweenTwoLocations(location1: CLLocationCoordinate2D, location2: CLLocationCoordinate2D) -> Double {

    // Use Haversine Formula to calculate the distance in meter between two locations
    // φ is latitude, λ is longitude, R is earth’s radius (mean radius = 6,371km)
    let lat1 = location1.latitude
    let lat2 = location2.latitude

    let lon1 = location1.longitude
    let lon2 = location2.longitude

    let earthRadius = 6371000.0

    let φ1 = lat1 * Double.pi / 180 // φ, λ in radians
    let φ2 = lat2 * Double.pi / 180

    let Δφ = (lat2 - lat1) * Double.pi / 180
    let Δλ = (lon2 - lon1) * Double.pi / 180

    let aaa = sin(Δφ/2) * sin(Δφ/2) + cos(φ1) * cos(φ2) * sin(Δλ/2) * sin(Δλ/2)
    let ccc = 2 * atan2(sqrt(aaa), sqrt(1-aaa))

    let distance = earthRadius * ccc

    return distance
  }
}
