//
//  ShopRouteCell.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/17.
//

import UIKit
import MapKit

class ShopRouteCell: ShopDetailBasicCell {
  
  @IBOutlet weak var mapView: MKMapView!

  @IBOutlet weak var address: UILabel!

  @IBOutlet weak var checkRouteButton: UIButton!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    mapView.delegate = self
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

  func markAnnotationForShop(shop: CoffeeShop) {

    let shopAnnotation = MKPointAnnotation()

    shopAnnotation.coordinate.longitude = shop.longitude

    shopAnnotation.coordinate.latitude = shop.latitude

    shopAnnotation.title = shop.name

    mapView.addAnnotation(shopAnnotation)

    let region = MKCoordinateRegion(center: shopAnnotation.coordinate, latitudinalMeters: 250, longitudinalMeters: 250)
                    self.mapView.setRegion(region, animated: false)
  }
}

extension ShopRouteCell: MKMapViewDelegate {

  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

    let identifier = "MyMarkerTwo"

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
