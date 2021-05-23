//
//  RecommendViewController.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/17.
//

import UIKit
import VerticalCardSwiper

class RecommendViewController: UIViewController, VerticalCardSwiperDatasource {
  
  private var cardSwiper: VerticalCardSwiper!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    cardSwiper = VerticalCardSwiper(frame: self.view.bounds)
    view.addSubview(cardSwiper)
    
    cardSwiper.datasource = self
    
    // register cardcell for storyboard use
    cardSwiper.register(nib: UINib(nibName: "ExampleCell", bundle: nil), forCellWithReuseIdentifier: "ExampleCell")
  }
  
  func cardForItemAt(verticalCardSwiperView: VerticalCardSwiperView, cardForItemAt index: Int) -> CardCell {
    
    if let cardCell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: "ExampleCell", for: index) as? ExampleCardCell {
      
      cardCell.setRandomBackgroundColor()
      return cardCell
    }
    return CardCell()
  }
  
  func numberOfCards(verticalCardSwiperView: VerticalCardSwiperView) -> Int {
    return 10
  }
}
