//
//  WeatherStore.swift
//  zion-code-test
//
//  Created by Pablo Epíscopo on 7/24/19.
//  Copyright © 2019 Pablo Epíscopo. All rights reserved.
//

import UIKit
import CoreLocation

typealias WeatherStoreBlock = (_ weather: Weather?, _ error: Error?) -> Void

class WeatherStore: NSObject {

    private static let key = "6c01041e3731f8813ce81a2b03405e95"

    class func weather(coordinate: CLLocationCoordinate2D, completion: WeatherStoreBlock?) {
        let path = "http://api.openweathermap.org/data/2.5/weather?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&APPID=\(key)"
        let url = URL(string: path)!
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard error == nil else {
                completion?(nil, error)
                return
            }
            guard let data = data else { return }
            let json = try! JSONSerialization.jsonObject(with: data, options: []) as! Dictionary
            if let weather = Weather(dictionary: json) {
                completion?(weather, nil)
            } else {
                completion?(nil, CustomError.emptyResponse)
            }
        }
        task.resume()

    }

}
