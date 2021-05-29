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
  var homeViewModel: HomeViewModel?

  var userCurrentCoordinate = CLLocationCoordinate2D()

  var shopsDataForMap: [CoffeeShop] = []

  var selectedAnnotation: MKPointAnnotation?

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view
    // 1:  When enter we check auth status
    locationManagerDidChangeAuthorization(LocationManager.shared.locationManager)

    // 2: Get user's current coordinate for drawing map
    LocationManager.shared.onCurrentCoordinate = { coordinate in

      self.userCurrentCoordinate = coordinate
    }

    // 3: Fetch shops within distance on Firebase
    self.homeViewModel?.getShopAroundUser()

    homeViewModel?.onShopsAnnotations = { [weak self] annotations in

      self?.mapView.showAnnotations(annotations, animated: true)
    }

    homeViewModel?.getShopsData = { [weak self] shopsData in

      self?.shopsDataForMap = shopsData
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

      print("Location access was restricted.")

    case .denied:

      print("User denied access to location.")

    case .notDetermined:

      print("Location status not determined.")

      manager.requestWhenInUseAuthorization()

    case .authorizedAlways, .authorizedWhenInUse:

      print("Location authorization is confirmed.")

      homeViewModel?.getShopAroundUser()

      setUpMapView()

    default:

      print("Unknown Error")
    }
  }
}

// MARK: - HomeMapViewModelDelegate
extension HomeMapViewController: HomeViewModelDelegate {

  func setUpMapView() {

    homeViewModel?.delegate = self

    mapView.delegate = self

    mapView.showsUserLocation = true

    mapView.userTrackingMode = .follow

    mapView.region = MKCoordinateRegion(
      center: userCurrentCoordinate,
      latitudinalMeters: 500,
      longitudinalMeters: 500
    )
  }
}

// MARK: - MKMapViewDelegate
extension HomeMapViewController: MKMapViewDelegate {

  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

    selectedAnnotation = view.annotation as? MKPointAnnotation

    print(selectedAnnotation?.title)

    // 選到時可用title去查是哪個
  }

  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

    let identifier = "MyMarker"

    if annotation.isKind(of: MKUserLocation.self) { return nil }

    var annotationView: MKMarkerAnnotationView? =
      mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView

    if annotationView == nil {
      annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
    }

    annotationView?.markerTintColor = UIColor.init(named: "B1")

    return annotationView
  }
}
