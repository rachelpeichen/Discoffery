//
//  CollectionViewFlowLayout.swift
//  DynamicHeightCollectionView
//
//  Created by Payal Gupta on 11/02/19.
//  Copyright © 2019 Payal Gupta. All rights reserved.
//  參考的
//// https://www.freecodecamp.org/news/how-to-make-height-collection-views-dynamic-in-your-ios-apps-7d6ca94d2212/
//
//  CollectionViewFlowLayout.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/25.
//

import UIKit

class CollectionViewFlowLayout: UICollectionViewFlowLayout {

  var tempCellAttributesArray = [UICollectionViewLayoutAttributes]()

  let leftEdgeInset: CGFloat = 10

  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

    let cellAttributesArray = super.layoutAttributesForElements(in: rect)
    // Oth position cellAttr is InConvience Emoji Cell, from 1st onwards info cells are there, thats why we start count from 2nd position.

    if cellAttributesArray != nil && cellAttributesArray!.count > 1 {

      for i in 1..<(cellAttributesArray!.count) {

        let prevLayoutAttributes: UICollectionViewLayoutAttributes = cellAttributesArray![i - 1]

        let currentLayoutAttributes: UICollectionViewLayoutAttributes = cellAttributesArray![i]

        let maximumSpacing: CGFloat = 8

        let prevCellMaxX: CGFloat = prevLayoutAttributes.frame.maxX

        // UIEdgeInset 16 from left
        let collectionViewSectionWidth = self.collectionViewContentSize.width - leftEdgeInset

        let currentCellExpectedMaxX = prevCellMaxX + maximumSpacing + (currentLayoutAttributes.frame.size.width)

        if currentCellExpectedMaxX < collectionViewSectionWidth {

          var frame: CGRect? = currentLayoutAttributes.frame

          frame?.origin.x = prevCellMaxX + maximumSpacing

          frame?.origin.y = prevLayoutAttributes.frame.origin.y

          currentLayoutAttributes.frame = frame ?? CGRect.zero

        } else {

          // self.shiftCellsToCenter()
          currentLayoutAttributes.frame.origin.x = leftEdgeInset

          // To Avoid InConvience Emoji Cell
          if prevLayoutAttributes.frame.origin.x != 0 {

            currentLayoutAttributes.frame.origin.y =

              prevLayoutAttributes.frame.origin.y +

              prevLayoutAttributes.frame.size.height + 08
          }
        }
        // print(currentLayoutAttributes.frame)
      }
      // print("Main For Loop End")
    }
    // self.shiftCellsToCenter()
    return cellAttributesArray
  }

  func shiftCellsToCenter() {

    if tempCellAttributesArray.isEmpty { return }

    let lastCellLayoutAttributes = self.tempCellAttributesArray[self.tempCellAttributesArray.count - 1]

    let lastCellMaxX: CGFloat = lastCellLayoutAttributes.frame.maxX

    let collectionViewSectionWidth = self.collectionViewContentSize.width - leftEdgeInset

    let xAxisDifference = collectionViewSectionWidth - lastCellMaxX

    if xAxisDifference > 0 {

      for each in self.tempCellAttributesArray {

        each.frame.origin.x += xAxisDifference / 2
      }
    }
  }
}
