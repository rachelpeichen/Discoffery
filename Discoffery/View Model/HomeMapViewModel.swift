//
//  HomeMapView.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/13.
//

import Foundation
import CoreLocation
import MapKit

protocol HomeMapViewModelDelegate: AnyObject {

  func setUpMapView()
}

class HomeMapViewModel {

  // swiftlint:disable force_unwrapping

  // MARK: - Properties
  weak var delegate: HomeMapViewModelDelegate?

  var userLocation: [String: Double] = [:]

  var onShopsAnnotations: (([MKPointAnnotation]) -> Void)?  // Pass from ViewModel to Controller by closure

  // MARK: - 這個只能裝一大包
  var shopsData: [CoffeeShop]? {

    didSet {

      guard let shopsData = shopsData else { return }
      
      markAnnotationForShops(shops: shopsData)
    }
  }

  // MARK: - Functions
  func getUserCoordinates() {

    LocationManager.shared.trackLocation { latitude, longitude in

      self.userLocation["latitude"] = latitude

      self.userLocation["longitude"] = longitude
    }
  }

  func getShopsBy500m() {

    CoffeeShopManager.shared.fetchShopByCoordinateRange { [weak self] result in

      switch result {

      case .success(let data):

        self?.shopsData = data

      case .failure(let error):

        print("getShopsCoordinates: \(error)")
      }
    }
  }

  func markAnnotationForShops(shops: [CoffeeShop]) {

    var shopAnnotations: [MKPointAnnotation] = []

    guard let shopsData = self.shopsData else { return }

    for index in 0..<shopsData.count {

      let shopAnnotation = MKPointAnnotation()

      shopAnnotation.coordinate.longitude = Double(shopsData[index].longitude)!

      shopAnnotation.coordinate.latitude = Double(shopsData[index].latitude)!

      shopAnnotation.title = shopsData[index].name

      shopAnnotations.append(shopAnnotation)
    }
    self.onShopsAnnotations?(shopAnnotations)
  }
}

//  let searchQuerys = ["coffee"]
//
//  var searchResults = [MKMapItem]()
// extension HomeMapViewController: CLLocationManagerDelegate {
// swiftlint:disable force_unwrapping
// 開啟startUpdatingLocation()會，觸發func locationManager, [CLLocation]會取得所有定位點，[0]為最新點
//  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//    let userLocation: CLLocation = locations[0] // 用戶當前位置
//
//    let request = MKLocalSearch.Request()
//
//    // 搜尋用戶坐標附近地點的範圍
//    request.region = MKCoordinateRegion(
//      center: userLocation.coordinate,
//      latitudinalMeters: 500,
//      longitudinalMeters: 500
//    )
//
//    for searchQuery in searchQuerys {
//
//      request.naturalLanguageQuery = searchQuery
//
//      let search = MKLocalSearch(request: request)
//
//      // 搜尋附近地點的結果
//      search.start { response, error in
//
//        guard let searchResponse = response else {
//
//          print(error)
//          return
//        }
//        // 所有關鍵字得到的資料放入searchResults
//        self.searchResults.append(contentsOf: searchResponse.mapItems)
//
//        print("搜尋結果：\(self.searchResults)")
//
//        // 為每一個搜尋加上標註
//
//        for item: MKMapItem in searchResponse.mapItems as [MKMapItem] {
//
//          let searchAnnotaion = MKPointAnnotation()
//
//          searchAnnotaion.coordinate = (item.placemark.coordinate)
//
//          searchAnnotaion.title = item.placemark.name
//
//          // Display the annotation
//          self.mapView.showAnnotations([searchAnnotaion], animated: true)
//
//          self.mapView.selectAnnotation(searchAnnotaion, animated: true)
//        }
//      }
//    }
//
//    //  將用戶的placemark轉成地址 現在用不到
//    CLGeocoder().reverseGeocodeLocation(userLocation) { placemark, error in
//      if error != nil {
//
//        print(error as Any)
//      } else {
//
//        // geocoder returns CLPlacemark objects, which contain both the coordinate and the original information that you provided
//        if let placemark = placemark?[0] {
//
//          var address = ""
//
//          if placemark.subThoroughfare != nil {
//
//            address += placemark.subThoroughfare! + " "
//          }
//
//          if placemark.thoroughfare != nil {
//
//            address += placemark.thoroughfare! + "\n"
//          }
//
//          if placemark.subLocality != nil {
//
//            address += placemark.subLocality! + "\n"
//          }
//
//          if placemark.subAdministrativeArea != nil {
//
//            address += placemark.subAdministrativeArea! + "\n"
//          }
//
//          if placemark.postalCode != nil {
//
//            address += placemark.postalCode! + "\n"
//          }
//
//          if placemark.country != nil {
//
//            address += placemark.country!
//          }
//          print("-----😛-----\(address)")
//        }
//      }
//    }
//  }
// }
