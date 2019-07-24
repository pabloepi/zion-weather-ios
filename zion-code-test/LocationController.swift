//
//  LocationController.swift
//  zion-code-test
//
//  Created by Pablo Epíscopo on 7/24/19.
//  Copyright © 2019 Pablo Epíscopo. All rights reserved.
//

import UIKit
import CoreLocation

typealias LocationControllerBlock = ((_ locations: [CLLocation]) -> Void)

class LocationController: NSObject, CLLocationManagerDelegate {

    static let shared = LocationController()

    private(set) var updating: Bool = false

    var status: CLAuthorizationStatus {
        get { return CLLocationManager.authorizationStatus() }
    }

    private var successBlock: CompletionBlock?
    private var failureBlock: CompletionBlock?
    private var deniedBlock: CompletionBlock?
    private var didFailWithErrorBlock: ErrorCompletionBlock?
    private var didUpdateLocationsBlock: LocationControllerBlock?

    private lazy var manager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.activityType = .fitness
        manager.allowsBackgroundLocationUpdates = true
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()

    // MARK: - public methods

    func requestLocationAuthorization(_ success: CompletionBlock?, failure: CompletionBlock?, denied: CompletionBlock?) {
        successBlock = success
        failureBlock = failure
        deniedBlock = denied
        manager.requestAlwaysAuthorization()
        manager.requestWhenInUseAuthorization()
    }

    func startUpdatingLocation(success: LocationControllerBlock?, failure: ErrorCompletionBlock?) {
        if CLLocationManager.locationServicesEnabled() {
            didUpdateLocationsBlock = success
            didFailWithErrorBlock = failure
            manager.startUpdatingLocation()
            manager.startMonitoringSignificantLocationChanges()
            updating = true
        } else {
            didFailWithErrorBlock?(CustomError.emptyResponse)
        }
    }

    func stopUpdatingLocation() {
        manager.stopUpdatingLocation()
        manager.stopMonitoringSignificantLocationChanges()
        updating = false
    }

    // MARK: cllocation manager delegate methods

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let newLocation = locations.last {
            if newLocation.timestamp.timeIntervalSinceNow > -3 && newLocation.horizontalAccuracy > 0 {
                didUpdateLocationsBlock?(locations)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse: successBlock?()
        case .denied: failureBlock?()
        case .notDetermined: failureBlock?()
        case .restricted: failureBlock?()
        @unknown default:
            failureBlock?()
        }

        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            updating = false
            didFailWithErrorBlock?(error)
        }
    }

}
