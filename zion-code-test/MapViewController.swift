//
//  MapViewController.swift
//  zion-code-test
//
//  Created by Pablo Epíscopo on 7/24/19.
//  Copyright © 2019 Pablo Epíscopo. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    private var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        initGUI()
        trackUser()
    }

    deinit {
        if LocationController.shared.status != CLAuthorizationStatus.authorizedAlways {
            if LocationController.shared.updating {
                LocationController.shared.stopUpdatingLocation()
            }
        }
    }

    override func updateViewConstraints() {
        mapView.toSuperviewBounds()
        super.updateViewConstraints()
    }

    // MARK: - private methods

    private func initGUI() {
        mapView = MKMapView(frame: CGRect.zero)
        view.addSubview(mapView)
    }

    private func updateLocation() {
        LocationController.shared.startUpdatingLocation(success: { [weak self] (locations) in
            guard let sself = self else { return }
            if !locations.isEmpty, let last = locations.last {
                let coordinates = last.coordinate
                let center = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                sself.mapView.setRegion(region, animated: true)

                let annotation: MKPointAnnotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2DMake(coordinates.latitude, coordinates.longitude);
                annotation.title = "Current Location"
                sself.mapView.addAnnotation(annotation)
            }
            }, failure: { [weak self] (error) in
                let alert = UIAlertController.locationErrorAlert(callHandler: nil)
                self?.present(alert, animated: true, completion: nil)
        })
    }

    private func trackUser() {
        let alertBlock: CompletionBlock = { [weak self] in
            let alert = UIAlertController.blockedFeatureAlert("localización")
            self?.present(alert, animated: true, completion: nil)
        }
        if LocationController.shared.status == .authorizedAlways || LocationController.shared.status == .authorizedWhenInUse {
            if !LocationController.shared.updating {
                updateLocation()
            }
        } else if LocationController.shared.status == .notDetermined {
            LocationController.shared.requestLocationAuthorization({ [weak self] in
                guard let sself = self else { return }
                sself.updateLocation()
            }, failure: nil, denied: alertBlock)
        } else if LocationController.shared.status == .denied {
            alertBlock()
        }
    }

}
