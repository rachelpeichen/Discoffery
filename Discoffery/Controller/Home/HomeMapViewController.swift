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

  var userCurrentCoordinate = CLLocationCoordinate2D()

  var apiData: [CoffeeShop] = []

  // MARK: - View Life Cycle
  override func viewDidLoad() {

    super.viewDidLoad()
    // Do any additional setup after loading the view

    locationManagerDidChangeAuthorization(LocationManager.shared.locationManager)

    LocationManager.shared.closure = { coordinate in

      self.userCurrentCoordinate = coordinate

      print(coordinate)
    }

    fetchAPIThenPublish()

    // homeMapViewModel.getShopsBy500m()

    homeMapViewModel.onShopsAnnotations = { [weak self] annotations in

      self?.mapView.showAnnotations(annotations, animated: true)
    }
  }

  // MARK: - Functions

  func calMappingeRange() {

    let currentLatitude = Double(userCurrentCoordinate.latitude)

    let currentLongitude = Double(userCurrentCoordinate.longitude)

    let newLatitudeUp = currentLatitude + (500 * 0.000008983)

    let newLongitudeUp = currentLongitude + (500 * 0.000008983) / cos(currentLatitude * (Double.pi / 180))

    let newLatitudeDown = currentLatitude + (-500 * 0.000008983)

    let newLongitudeDown = currentLongitude + (-500 * 0.000008983) / cos(currentLatitude * (Double.pi / 180))

    print("有夠土炮靠杯🙄")

    print("現在的緯度是\(currentLatitude)現在的經度是\(currentLongitude)")

    print("新緯度上限是\(newLatitudeUp)新經度上限是\(newLongitudeUp)")

    print("新緯度下限是\(newLatitudeDown)新經度下限是\(newLongitudeDown)")
  }

  // MARK: - Publish API data to Firebase (only used at first time)

  func fetchAPIThenPublish() {

    APIManager.shared.request { result in

      for index in 0..<10 {

        self.apiData.append(result[index])

        self.publishToFirebase(with: &self.apiData[index])

        self.updateGeoOnFirebase(with: &self.apiData[index])
      }
      print(self.apiData)

      print("API總共抓到\(String(describing: self.apiData.count))筆資料")
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

  func updateGeoOnFirebase(with shop: inout CoffeeShop) {

    CoffeeShopManager.shared.updateShopGeo(shop: &shop) { result in

      switch result {

      case .success:

        print("🍈Update Geo on Firebase Success!!")

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

    homeMapViewModel.delegate = self

    mapView.delegate = self

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
