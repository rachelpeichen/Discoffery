//
//  HomeMapViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/12.
//

import UIKit
import MapKit
import CoreLocation

class HomeMapViewController: UIViewController {

  // MARK: - Outlets
  @IBOutlet var mapView: MKMapView!

  // MARK: - Properties
  var locationManager = CLLocationManager()
  
  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    trackUserLocation()
  }

  // MARK: - Functions
  func trackUserLocation() { // 放在這裡適合嗎？確認MVVM的話這個放在哪

    locationManager.delegate = self

    locationManager.desiredAccuracy = kCLLocationAccuracyBest

    locationManager.requestWhenInUseAuthorization()

    locationManager.startUpdatingLocation()

    mapView.delegate = self

    mapView.showsUserLocation = true

    mapView.userTrackingMode = .follow
  }
}

extension HomeMapViewController: MKMapViewDelegate {

  // 每次當地圖視圖需要顯示一個標註時這個方法會被呼叫 現在無用
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

    let identifier = "MyMarker"

    if annotation.isKind(of: MKUserLocation.self) {
      return nil
    }

    // 如果可行即將標註再重複使用
    var annotationView: MKMarkerAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView

    if annotationView == nil {

      annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
    }
    annotationView?.glyphText = "😋"

    annotationView?.markerTintColor = UIColor.orange

    return annotationView
  }
}

extension HomeMapViewController: CLLocationManagerDelegate {

  // swiftlint:disable force_unwrapping

  // 開啟update位置後 startUpdatingLocation()，觸發func locationManager, [CLLocation]會取得所有定位點，[0]為最新點 這是取得用戶的
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

    print("-----😛-----\(locations)")
    let userLocation: CLLocation = locations[0]

    CLGeocoder().reverseGeocodeLocation(userLocation) { placemark, error in

      if error != nil {

        print(error as Any)
      } else {

        // geocoder  returns CLPlacemark objects, which contain both the coordinate and the original information that you provided
        if let placemark = placemark?[0] {

          print(placemark)
          var address = ""

          if placemark.subThoroughfare != nil {

            address += placemark.subThoroughfare! + " "
          }

          if placemark.thoroughfare != nil {

            address += placemark.thoroughfare! + "\n"
          }

          if placemark.subLocality != nil {

            address += placemark.subLocality! + "\n"
          }

          if placemark.subAdministrativeArea != nil {

            address += placemark.subAdministrativeArea! + "\n"
          }

          if placemark.postalCode != nil {

            address += placemark.postalCode! + "\n"
          }

          if placemark.country != nil {

            address += placemark.country!
          }
          print("-----😛-----\(address)")
        }
      }
    }
  }

  // 將地址轉換為座標

  func transformAddressToPlacemark() {

    let geoCoder = CLGeocoder()

    geoCoder.geocodeAddressString("524 Ct St, Brooklyn, NY 11231",completionHandler: { placemark, error in
      // 處理地面目標

    })


  }
}


