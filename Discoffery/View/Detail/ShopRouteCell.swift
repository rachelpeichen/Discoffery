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

  @IBOutlet weak var walkingTimes: UILabel!

  @IBOutlet weak var address: UILabel!

  @IBOutlet weak var distance: UILabel!

  @IBOutlet weak var checkRouteButton: UIButton!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
