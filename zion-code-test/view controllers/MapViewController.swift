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

class MapViewController: UIViewController, UIGestureRecognizerDelegate {

    private var mapView: MKMapView!
    private var doubleTapGesture: UITapGestureRecognizer!

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
        title = NSLocalizedString("Map", comment: "")
        mapView = MKMapView(frame: CGRect.zero)
        view.addSubview(mapView)

        doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapGestureAction(gesture:)))
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.numberOfTouchesRequired = 1
        doubleTapGesture.delegate = self
        mapView.addGestureRecognizer(doubleTapGesture)
    }

    @objc private func doubleTapGestureAction(gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: mapView)
        let coordinates = mapView.convert(point, toCoordinateFrom: view)
        WeatherStore.weather(coordinate: coordinates) { [weak self] (weather, error) in
            guard let sself = self else { return }
            guard error == nil else {
                let alert = UIAlertController.weatherErrorAlert(callHandler: nil)
                DispatchQueue.main.async {
                    self?.present(alert, animated: true, completion: nil)
                }
                return
            }
            guard let weather = weather else {
                let alert = UIAlertController.weatherErrorAlert(callHandler: nil)
                DispatchQueue.main.async {
                    self?.present(alert, animated: true, completion: nil)
                }
                return
            }
            let cachedObject = LocationCacheController.cachedLocation(coordinate: coordinates, weather: weather)
            let vc = LocationViewController()
            vc.location = cachedObject
            DispatchQueue.main.async {
                sself.show(vc, sender: nil)
            }
        }
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
                if LocationController.shared.updating {
                    LocationController.shared.stopUpdatingLocation()
                }
            }
            }, failure: { [weak self] (error) in
                let alert = UIAlertController.locationErrorAlert(callHandler: nil)
                DispatchQueue.main.async {
                    self?.present(alert, animated: true, completion: nil)
                }
        })
    }

    private func trackUser() {
        let alertBlock: CompletionBlock = { [weak self] in
            let alert = UIAlertController.blockedFeatureAlert("localización")
            DispatchQueue.main.async {
                self?.present(alert, animated: true, completion: nil)
            }
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

    // MARK: - uigesture recognizer delegate

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}
