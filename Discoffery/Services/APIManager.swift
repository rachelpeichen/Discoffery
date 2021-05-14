//
//  APIManager.swift
//  Discoffery
//
//  Created by Pei Pei on 2021/5/13.
//

import Foundation
import Alamofire

class APIManager {

  static let shared = APIManager()

  func request(requestURL: String = "https://cafenomad.tw/api/v1.2/cafes/taipei", closure: @escaping ([CoffeeShop]) -> Void) {

    AF.request(requestURL, method: .get, encoding: JSONEncoding.default).responseJSON { response in

      switch response.result {

      case .success:

        if let jsonData = response.data {

          // print("👻 Get response = \(response)")
          
          do {

            let decoder = JSONDecoder()

            let coffeeShopsData: [CoffeeShop] = try decoder.decode([CoffeeShop].self, from: jsonData)

            // 傳入data([CoffeeShop]型別)給Closure
            closure(coffeeShopsData)
          } catch let DecodingError.dataCorrupted(context) {

            print(context)
          } catch let DecodingError.keyNotFound(key, context) {

            print(DecodingError.keyNotFound(key, context))
          } catch let DecodingError.valueNotFound(value, context) {

            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
          } catch let DecodingError.typeMismatch(type, context) {

            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
          } catch let error as NSError {

            print("Failed to load: \(error.localizedDescription)")
          }
        }

      case.failure(let error):
        print("Request error: \(error.localizedDescription)")
      }
    }
  }
}
