//
//  HomeMapViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/12.
//

import UIKit
import MapKit

class HomeMapViewController: UIViewController {

  // MARK: - Outlets
  @IBOutlet var mapView: MKMapView!

  // MARK: - Properties
  var homeMapViewModel = HomeMapViewModel()

  var coffeeShopManager = CoffeeShopManager()

  var locataionManager = LocationManager.shared.locationManager

  var userCurrentCoordinate = CLLocationCoordinate2D()

  // MARK: - View Life Cycle
  override func viewDidLoad() {

    super.viewDidLoad()
    // Do any additional setup after loading the view

    locationManagerDidChangeAuthorization(locataionManager)

    LocationManager.shared.closure = { coordinate in

      self.userCurrentCoordinate = coordinate

      print(coordinate)

    }

    homeMapViewModel.getShopsBy500m()

    homeMapViewModel.onShopsAnnotations = { [weak self] annotations in

      self?.mapView.showAnnotations(annotations, animated: true)
    }
  }

  // MARK: - Functions

  func calMappingeRange(){

    // 1 degree in google map is equal to 111.32 Kilometer.
    // 1 Degree = 111.32KM.
    // 1KM in Degree = 1 / 111.32 = 0.008983.
    // 1M in Degree = 0.000008983.

    let currentLatitude = Double(userCurrentCoordinate.latitude)

    let currentLongitude = Double(userCurrentCoordinate.longitude)

    var newLatitudeUp = currentLatitude + (500 * 0.000008983)

    var newLongitudeUp = currentLongitude + (500 * 0.000008983) / cos(currentLatitude * (Double.pi / 180))

    var newLatitudeDown = currentLatitude + (-500 * 0.000008983)

    var newLongitudeDown = currentLongitude + (-500 * 0.000008983) / cos(currentLatitude * (Double.pi / 180))

    print("有夠土炮靠杯🙄")

    print("現在的緯度是\(currentLatitude)現在的經度是\(currentLongitude)")

    print("新緯度上限是\(newLatitudeUp)新經度上限是\(newLongitudeUp)")

    print("新緯度下限是\(newLatitudeDown)新經度下限是\(newLongitudeDown)")


    // MARK: - 偶不會三角函數啦幹我要算以現在座標上下左右五百公尺範圍的經緯度
//    let currentLatitude = Double(userCurrentCoordinate.latitude)
//
//    let currentLongitude = Double(userCurrentCoordinate.longitude)
//
//    var earthRadius = 6378.137 // in kilometer
//
//    var pi = Double.pi
//
//    var cosinus = cos(90 * pi / 180)
//
//    var m = (1 / ((2 * pi / 360) * earthRadius)) / 1000  // 1 meter in degree
//
//    var newLatitude = currentLatitude + (500 * m)
//
//     var newLongitude = currentLongitude + (500 * m) / cosinus(currentLatitude * (pi / 180))
  }

  // MARK: - Publish API data to Firebase (only used at first time)
  var apiData: [CoffeeShop]?

  func fetchAPIdata() {

    APIManager.shared.request { result in

      self.apiData = result

      print("API總共抓到\(String(describing: self.apiData?.count))筆資料")

      for index in 0..<100 {

        self.publishToFirebase(with: &self.apiData![index])
      }
    }
  }

  func publishToFirebase(with shop: inout CoffeeShop) {

    CoffeeShopManager.shared.publishShop(shop: &shop) { result in

      switch result {

      case .success:

        print("🥴Publish To Firebase Success!!")

      case .failure(let error):

        print("\(error)")
      }
    }
  }
}

// MARK: - CLLocationManagerDelegate
extension HomeMapViewController: CLLocationManagerDelegate {

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    // Tells the delegate when the app creates the location manager and when the authorization status changes

    manager.delegate = self

    switch manager.authorizationStatus {

    case .restricted:
      print("⛔️ Location access was restricted.")

    case .denied:
      print("🚫 User denied access to location.")

    case .notDetermined:
      print("❓Location status not determined.")

      manager.requestWhenInUseAuthorization()

    case .authorizedAlways, .authorizedWhenInUse:
      print("👌🏻Location status is OK.")

      homeMapViewModel.getUserCoordinates()

      setUpMapView()

    default:
      print("🙄 蝦小")
    }
  }
}

// MARK: - HomeMapViewModelDelegate
extension HomeMapViewController: HomeMapViewModelDelegate {

  func setUpMapView() {

    homeMapViewModel.delegate = self // HomeMapViewModelDelegate

    mapView.delegate = self // MKMapViewDelegate

    mapView.showsUserLocation = true

    mapView.userTrackingMode = .follow

    mapView.region = MKCoordinateRegion(
      center: userCurrentCoordinate,
      latitudinalMeters: 500,
      longitudinalMeters: 500
    )
    calMappingeRange()
  }
}

// MARK: - MKMapViewDelegate
extension HomeMapViewController: MKMapViewDelegate {

  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

    let identifier = "MyMarker"

    if annotation.isKind(of: MKUserLocation.self) { return nil }

    var annotationView: MKMarkerAnnotationView? =
      mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView

    if annotationView == nil {

      annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
    }

    annotationView?.glyphText = "☕️"
    annotationView?.markerTintColor = .brown

    return annotationView
  }
}
