//
//  LocationCacheController.swift
//  zion-code-test
//
//  Created by Pablo Epíscopo on 7/24/19.
//  Copyright © 2019 Pablo Epíscopo. All rights reserved.
//

import UIKit
import CoreLocation

struct LocationCache {
    let weather: Weather
    let coordinates: CLLocationCoordinate2D
}

class LocationCacheController: NSObject {

    private static var cached = [LocationCache]()

    class func cachedLocation(coordinate: CLLocationCoordinate2D, weather: Weather) -> LocationCache {
        let filtered = cached.filter({ $0.coordinates.latitude == coordinate.latitude && $0.coordinates.longitude == coordinate.longitude })
        if filtered.isEmpty {
            let obj = LocationCache(weather: weather, coordinates: coordinate)
            cached.append(obj)
            return obj
        } else {
            return filtered.first!
        }
    }

}
