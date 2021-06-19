//
//  HomeMapViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/12.
//

import UIKit
import MapKit

class HomeMapViewController: UIViewController {

  // MARK: - Properties
  var homeViewModel = HomeViewModel()

  var shopsDataForMap: [CoffeeShop] = []

  var featureDic: [String: [Feature]] = [:]

  var recommendItemsDic: [String: [RecommendItem]] = [:]

  var selectedShopAnnotation: MKPointAnnotation?

  var selectedShop: CoffeeShop?

  var selectedShopVC: SelectedShopViewController?

  var selectedAnnotationIndex: Int?
  
  // MARK: - IBOutlets & IBActions
  @IBOutlet var mapView: MKMapView!
  @IBOutlet weak var selecetedShopContainerView: UIView!
  @IBOutlet weak var centerLocationBtn: CustomBtn!

  @IBAction func onTapCenterLocationBtn(_ sender: Any) {

    if let coordinate = self.homeViewModel.userCurrentCoordinate {

      mapView.setCenter(coordinate, animated: true)
    }
  }

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view
    // 1:  When enter we check auth status
    locationManagerDidChangeAuthorization(LocationManager.shared.locationManager)
    
    // 2: Get user's current coordinate for drawing map
    homeViewModel.getUserCurrentCoordinate()

    // 3: Get shopsData
    homeViewModel.onShopsDataForMap = { shops in

      self.shopsDataForMap = shops
    }

    // 4: Mark shops on map
    homeViewModel.onShopsAnnotationsForMap = { [weak self] annotations in

      self?.mapView.showAnnotations(annotations, animated: true)
    }

    // 5: Get shops feature & recommend item

    // 6: Get distance between shop and user

//    selecetedShopContainerView.isHidden = true
  }

  // MARK: - Prepare Segue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    if segue.identifier == "selectedShopVC" {

      if let destinationVC = segue.destination as? SelectedShopViewController {

        selectedShopVC = destinationVC

        destinationVC.delegate = self
      }

    } else if segue.identifier == "navigateSelectedShopVCToDetailVC" {

      guard let index = selectedAnnotationIndex  else { return }

      let selectedShopToDetailVC = shopsDataForMap[index]

      if let detailVC = segue.destination as? DetailViewController {

        detailVC.shop = selectedShopToDetailVC

        guard let featureArr = featureDic[selectedShopToDetailVC.id] else { return }

        detailVC.feature = featureArr[0]

        guard let recommendItemsArr = recommendItemsDic[selectedShopToDetailVC.id] else { return }

        detailVC.recommendItemsArr = recommendItemsArr
      }
    }
  }
}

// MARK: - CLLocationManagerDelegate：拉成兩個func整理
extension HomeMapViewController: CLLocationManagerDelegate {
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    
    // Tells the delegate when the app creates the location manager and when the authorization status changes
    manager.delegate = self
    
    if #available(iOS 14.0, *) {
      // MARK: Auth check for version iOS 14.0 and above
      switch manager.authorizationStatus {

      case .restricted:
        print("Location access was restricted.")

      case .denied:
        showLocationAuthDeniedDialog()
        print("User denied access to location.")

      case .notDetermined:
        print("Location status not determined.")
        manager.requestWhenInUseAuthorization()

      case .authorizedAlways, .authorizedWhenInUse:
        print("Location authorization is confirmed.")
        homeViewModel.fetchShopsAroundUser(distance: 2000)
        setUpMapView()

      default:
        print("Unknown Location Authorization Error")
      }

    } else {
      // MARK: Fallback on Earlier iOS Versions
      if CLLocationManager.locationServicesEnabled() {

        switch CLLocationManager.authorizationStatus() {

        case .restricted:
          print("Location access was restricted.")

        case .denied:
          showLocationAuthDeniedDialog()
          print("User denied access to location.")

        case .notDetermined:
          print("Location status not determined.")
          manager.requestWhenInUseAuthorization()

        case .authorizedAlways, .authorizedWhenInUse:
          print("Location authorization is confirmed.")
          homeViewModel.fetchShopsAroundUser(distance: 2000)
          setUpMapView()

        default:
          print("Unknown Location Authorization Error")
        }
      }
    }
  }
}

// MARK: - HomeMapViewModelDelegate
extension HomeMapViewController: HomeViewModelDelegate {
  
  func setUpMapView() {
    
    homeViewModel.delegate = self
    
    mapView.delegate = self
    mapView.showsUserLocation = true
    mapView.userTrackingMode = .follow

    if let coordinate = homeViewModel.userCurrentCoordinate {

      mapView.region = MKCoordinateRegion(center: coordinate,
                                          latitudinalMeters: 1000,
                                          longitudinalMeters: 1000)
    }
  }
}

// MARK: - MKMapViewDelegate
extension HomeMapViewController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

    selectedShopAnnotation = view.annotation as? MKPointAnnotation

    for (index, item) in shopsDataForMap.enumerated() {

      if let title = selectedShopAnnotation?.title {

        if item.name == title {
          selectedAnnotationIndex = index
        }
      }
    }

    for shop in shopsDataForMap where shop.name == selectedShopAnnotation?.title {

      if let selectedShopRecommendItem = recommendItemsDic[shop.id] {

        if let selectedsShopFeature = featureDic[shop.id] {

          selectedShopVC?.layoutSelectedShopVC(shop: shop,
                                              feature: selectedsShopFeature[0],
                                              recommendItem: selectedShopRecommendItem)
          selecetedShopContainerView.isHidden = false
        }
      }
    }
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

// MARK: - SelectedShopViewControllerDelegate
extension HomeMapViewController: SelectedShopViewControllerDelegate {

  func didTouchSelectedVC(_ sender: Any) {
    
    performSegue(withIdentifier: "navigateSelectedShopVCToDetailVC", sender: sender)
  }
}
