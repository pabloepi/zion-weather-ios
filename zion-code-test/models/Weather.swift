//
//  Weather.swift
//  zion-code-test
//
//  Created by Pablo Epíscopo on 7/24/19.
//  Copyright © 2019 Pablo Epíscopo. All rights reserved.
//

import Foundation

struct Weather {

    let description: String
    let temp: String
    let humidity: Int?

    init?(dictionary: Dictionary) {
        guard let main = dictionary["main"] as? Dictionary else {
            return nil
        }
        guard let weather = dictionary["weather"] as? [Dictionary] else {
            return nil
        }
        description = (weather.first?["description"] as? String)?.capitalized ?? "No description"
        humidity = main["humidity"] as? Int
        if let temperature = main["temp"] as? Double {
            let formatter = MeasurementFormatter()
            let measurement = Measurement(value: temperature, unit: UnitTemperature.celsius)
            temp = formatter.string(from: measurement)
        } else {
            temp = "No temperature"
        }
    }

}
