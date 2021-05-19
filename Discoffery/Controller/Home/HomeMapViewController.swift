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

  var apiData: [CoffeeShop]?

  // MARK: - View Life Cycle
  override func viewDidLoad() {

    super.viewDidLoad()
    // Do any additional setup after loading the view

    locationManagerDidChangeAuthorization(LocationManager.shared.locationManager)

    homeMapViewModel.onShopsAnnotations = { [weak self] annotations in

      self?.mapView.showAnnotations(annotations, animated: true)
    }
  }

  // MARK: - Functions
  func fetchAPIdata() {
    // Publish API data to Firebase (only used at first time)

    APIManager.shared.request { result in

      self.apiData = result

      print("🥴API總共抓到\(String(describing: self.apiData?.count))筆資料")

      for index in 0..<100 {

        self.publishToFirebase(with: &self.apiData![index])
      }
    }
  }

  func publishToFirebase(with shop: inout CoffeeShop) {
    // Publish API data to Firebase (only used at first time)

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

// MARK: - HomeMapViewModelDelegate
extension HomeMapViewController: HomeMapViewModelDelegate {

  func setUpMapView() {

    homeMapViewModel.delegate = self // 這是 HomeMapViewModelDelegate

    mapView.delegate = self // 這是 MKMapViewDelegate

    mapView.showsUserLocation = true

    mapView.userTrackingMode = .follow
  }
}

// MARK: - MKMapViewDelegate
extension HomeMapViewController: MKMapViewDelegate {

  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

    let identifier = "MyMarker"

    if annotation.isKind(of: MKUserLocation.self) { return nil }

    var annotationView: MKMarkerAnnotationView? =
      mapView.dequeueReusableAnnotationView(withIdentifier: identifier)as? MKMarkerAnnotationView

    if annotationView == nil {

      annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
    }

    annotationView?.glyphText = "☕️"
    annotationView?.markerTintColor = .brown

    return annotationView
  }
}

// MARK: - MKMapViewDelegate
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
