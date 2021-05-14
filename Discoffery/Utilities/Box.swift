//
//  Box.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/13.
//
// From raywenderlich:https://www.raywenderlich.com/6733535-ios-mvvm-tutorial-refactoring-from-mvc#toc-anchor-008

import Foundation

final class Box<T> {

  // 1
  typealias Listener = (T) -> Void
  var listener: Listener?

  // 2
  var value: T {
    didSet {
      listener?(value)
    }
  }

  // 3
  init(_ value: T) {
    self.value = value
  }

  // 4
  func bind(listener: Listener?) {
    self.listener = listener
    listener?(value)
  }
}

// Boxing：使用屬性觀察器通知觀察器值已經更改。
// 1. 每個Box都會有一個Listener，當值被更改了就會通知Box。
//
// 2. Box具有泛型值，當didSet觀察到任何的更改，就會通知Listener。
//
// 3. 初始化Box的初始值。
//
// 4. 當一個Listener在Box上調用bind(listener:)時，它會成為Listener，並且立即得到Box的當前值的通知。
