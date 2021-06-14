//
//  MapRouteViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/6/14.
//

import UIKit
import MapKit

class MapRouteViewController: UIViewController {

  @IBOutlet weak var mapView: MKMapView!

  @IBOutlet weak var backBtn: UIButton!

  @IBAction func onTapBackBtn(_ sender: Any) {

    self.dismiss(animated: true, completion: nil)
  }

  // MARK: - Properties
  var shopName: String?

  var shopLocation = CLLocationCoordinate2D()

  var userCurrentCoordinate = CLLocationCoordinate2D()

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
   userCurrentCoordinate = LocationManager.shared.currentCoordinate

    mapView.showsUserLocation = true

    mapView.delegate = self

    showDirection()
  }
}

extension MapRouteViewController: MKMapViewDelegate {

  func showDirection() {

    // 1.
    let shopPlacemark = MKPlacemark(coordinate: shopLocation, addressDictionary: nil)

    // 2.
    let shopMapItem = MKMapItem(placemark: shopPlacemark)

    // 3. Show annotations on map
    let shopAnnotation = MKPointAnnotation()

    shopAnnotation.title = shopName

    if let shopLocation = shopPlacemark.location {
      shopAnnotation.coordinate = shopLocation.coordinate
    }

    mapView.showAnnotations([shopAnnotation], animated: true)

    // 4. Request for directions
    let directionRequest = MKDirections.Request()

    directionRequest.source = MKMapItem.forCurrentLocation()

    directionRequest.destination = shopMapItem

    directionRequest.transportType = .walking

    // 5: Calculate the direction
    let directions = MKDirections(request: directionRequest)

    directions.calculate { routeResponse, routeError -> Void in

      guard let routeResponse = routeResponse else {

        if let routeError = routeError {

          print("Error: \(routeError)")
        }
        return
      }

      let route = routeResponse.routes[0]

      self.mapView.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)

      let rect = route.polyline.boundingMapRect

      self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
    }
  }

  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

    let renderer = MKPolylineRenderer(overlay: overlay)

    renderer.strokeColor = .B1

    renderer.lineWidth = 4.0

    return renderer
  }

  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

    let identifier = "MyMarker"

    if annotation.isKind(of: MKUserLocation.self) { return nil }

    var annotationView: MKMarkerAnnotationView? =
      mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView

    if annotationView == nil {
      annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
    }

    annotationView?.markerTintColor = .B2

    annotationView?.glyphText = "☕️"

    return annotationView
  }
}
