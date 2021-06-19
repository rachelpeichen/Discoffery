//
//  UIStoryboard+Extension.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/6/5.
//

import UIKit

enum StoryboardCategory {
  public static let main = "Main"
  public static let login = "Login"
}

extension UIStoryboard {

  static var main: UIStoryboard {
    return storyboard(name: StoryboardCategory.main)
  }

  static var login: UIStoryboard {
    return storyboard(name: StoryboardCategory.login)
  }

  private static func storyboard(name: String) -> UIStoryboard {
    return UIStoryboard(name: name, bundle: nil)
  }
}
