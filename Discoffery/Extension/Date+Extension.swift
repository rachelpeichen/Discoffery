//
//  Date+Extension.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/25.
//

import Foundation

extension Date {

  var millisecondsSince1970: Int64 {

    return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
  }

  init(milliseconds: Int64) {

    self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
  }

  static var dateFormatter: DateFormatter {

    let formatter = DateFormatter()

    formatter.dateFormat = "yyyy.MM.dd HH:mm"

    return formatter
  }
}

extension Date {

  // MARK: Generate a random date within given range

  static func randomBetween(start: String, end: String, format: String = "yyyy-MM-dd") -> String {

    let date1 = Date.parse(start, format: format)

    let date2 = Date.parse(end, format: format)

    return Date.randomBetween(start: date1, end: date2).dateString(format)
  }

  static func randomBetween(start: Date, end: Date) -> Date {

    var date1 = start

    var date2 = end

    if date2 < date1 {

      let temp = date1

      date1 = date2

      date2 = temp
    }

    let span = TimeInterval.random(in: date1.timeIntervalSinceNow...date2.timeIntervalSinceNow)

    return Date(timeIntervalSinceNow: span)
  }

  func dateString(_ format: String = "yyyy-MM-dd") -> String {

    let dateFormatter = DateFormatter()

    dateFormatter.dateFormat = format

    return dateFormatter.string(from: self)
  }

  static func parse(_ string: String, format: String = "yyyy-MM-dd") -> Date {

    let dateFormatter = DateFormatter()

    dateFormatter.timeZone = NSTimeZone.default

    dateFormatter.dateFormat = format

    let date = dateFormatter.date(from: string)!
    
    return date
  }
}
