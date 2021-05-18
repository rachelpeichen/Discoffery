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

  var locationManager = CLLocationManager()

  var coffeeShopManager = CoffeeShopManager()

  var APIdata: [CoffeeShop]?

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view

    //trackUserLocation()

    //homeMapViewModel.fetchData()

    //    homeMapViewModel.onShopsAnnotations = { [weak self] annotations in
    //
    //      self?.mapView.showAnnotations(annotations, animated: true)
    //    }
    
    APIManager.shared.request { result in

      self.APIdata = result

      print("🥴API總共抓到\(String(describing: self.APIdata?.count))筆資料")

      for index in 0..<10 {

        self.publishToFirebase(with: &self.APIdata![index])
      }
    }
  }

  // MARK: - Functions
  // Publish API data to Firebase (Only used at first time)
  func publishToFirebase(with shop: inout CoffeeShop) {

    CoffeeShopManager.shared.publishShop(shop: &shop) { result in

      switch result {

      case .success:

        print("🥴Publish To Firebase Success")

      case .failure(let error):

        print("\(error)")
      }
    }
  }

  func trackUserLocation() { // MVVM的話這個放在哪？？？？ LocationManager???

    // locationManager.delegate = self

    locationManager.desiredAccuracy = kCLLocationAccuracyBest

    locationManager.requestWhenInUseAuthorization()

    locationManager.startUpdatingLocation()

    mapView.delegate = self

    mapView.showsUserLocation = true

    mapView.userTrackingMode = .follow
  }
}

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
