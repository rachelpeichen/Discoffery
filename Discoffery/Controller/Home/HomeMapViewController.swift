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

    homeMapViewModel.delegate = self

    homeMapViewModel.getUserLocation()

    setUpMapView()

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

    mapView.delegate = self

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
