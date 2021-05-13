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

  let searchQuerys = ["coffee"]

  var searchResults = [MKMapItem]()

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    trackUserLocation()

    // transformAddressToPlacemark()
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

  // 每次當地圖視圖需要顯示一個標註時這個方法會被呼叫
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

    let annotationLabel = UILabel(frame: CGRect(x: -35, y: -60, width: 120, height: 40))

    annotationLabel.adjustsFontSizeToFitWidth = true
    annotationLabel.numberOfLines = 0

//    annotationLabel.text = "編號"
//    annotationLabel.textColor = .white
//    annotationLabel.textAlignment = .center
//    annotationLabel.backgroundColor = .brown
//    annotationLabel.layer.cornerRadius = 10
//    annotationLabel.clipsToBounds = true
//    annotationView?.addSubview(annotationLabel)

    annotationView?.glyphText = "☕️"
    annotationView?.markerTintColor = UIColor.brown

    return annotationView
  }
}

extension HomeMapViewController: CLLocationManagerDelegate {

  // swiftlint:disable force_unwrapping

  // 開啟update位置後 startUpdatingLocation()，觸發func locationManager, [CLLocation]會取得所有定位點，[0]為最新點 這是取得用戶的
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

    let userLocation: CLLocation = locations[0] //用戶當前位置

    let request = MKLocalSearch.Request()

    // 搜尋用戶坐標附近地點的範圍
    request.region = MKCoordinateRegion(
      center: userLocation.coordinate,
      latitudinalMeters: 500,
      longitudinalMeters: 500
    )

    for searchQuery in searchQuerys {

      request.naturalLanguageQuery = searchQuery

      let search = MKLocalSearch(request: request)

      // 搜尋附近地點的結果
      search.start { response, error in

        guard let searchResponse = response else {

          print(error)
          return
        }
        // 所有關鍵字得到的資料放入searchResults
        self.searchResults.append(contentsOf: searchResponse.mapItems)

        print("搜尋結果：\(self.searchResults)")

        // 為每一個搜尋加上標註

        for item: MKMapItem in searchResponse.mapItems as [MKMapItem] {

          let searchAnnotaion = MKPointAnnotation()

          searchAnnotaion.coordinate = (item.placemark.coordinate)

          searchAnnotaion.title = item.placemark.name

          // Display the annotation
          self.mapView.showAnnotations([searchAnnotaion], animated: true)

          self.mapView.selectAnnotation(searchAnnotaion, animated: true)
        }
      }
    }
    
    //  將用戶的placemark轉成地址 現在用不到
    CLGeocoder().reverseGeocodeLocation(userLocation) { placemark, error in
      if error != nil {

        print(error as Any)
      } else {

        // geocoder returns CLPlacemark objects, which contain both the coordinate and the original information that you provided
        if let placemark = placemark?[0] {

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
  // 將地址轉換為座標並標在地圖上 之後要用到的
  func transformAddressToPlacemark() {

    let geoCoder = CLGeocoder()

    geoCoder.geocodeAddressString("台北市大安區光復南路116巷18號",completionHandler: { placemarks, error in

      if let error = error {

        print(error)
        return
      }

      if let placemarks = placemarks {
        // Get the first placemark
        let placemark = placemarks[0]

        // Add annotation
        let annotation = MKPointAnnotation()

        if let location = placemark.location {

          annotation.coordinate = location.coordinate

          annotation.title = "財產署"

          // Display the annotation
          self.mapView.showAnnotations([annotation], animated: true)

          self.mapView.selectAnnotation(annotation, animated: true)
        }
      }
    })
  }
}
