//
//  KeywordsCollectionViewCell.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/31.
//

import UIKit

class KeywordsCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var keywordBtn: UIButton!

  @IBAction func didTouchKeywordBtn(_ sender: UIButton) {

  }

  override func awakeFromNib() {
    super.awakeFromNib()

    // Initialization code
    keywordBtn.addShadow()

  }

  func layoutKeywordCollectionViewCell(from: String) {

    keywordBtn.setTitle(from, for: .normal)

//    let buttonTitleSize = (from as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
//
//    keywordBtn.frame.size.width = buttonTitleSize.width + 30
  }

}
