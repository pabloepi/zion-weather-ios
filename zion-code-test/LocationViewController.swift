//
//  LocationViewController.swift
//  zion-code-test
//
//  Created by Pablo Epíscopo on 7/24/19.
//  Copyright © 2019 Pablo Epíscopo. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {

    var location: LocationCache!

    private var stackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        initGUI()
    }

    override func updateViewConstraints() {
        stackView.toSuperviewBounds(constant: nil)
        super.updateViewConstraints()
    }

    // MARK: - private methods

    private func initGUI() {
        title = NSLocalizedString("Weather", comment: "")
        view.backgroundColor = .white

        let labelDescription = UILabel()
        let labelTemperature = UILabel()
        let labelHumidity = UILabel()
        labelDescription.font = UIFont.systemFont(ofSize: 34, weight: UIFont.Weight.semibold)
        labelTemperature.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.semibold)
        labelHumidity.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.semibold)
        labelDescription.text = location.weather.description
        labelTemperature.text = location.weather.temp
        labelHumidity.text = location.weather.humidity != nil ? "\(location.weather.humidity!) %" : "No humidity"
        let array = [labelDescription, labelTemperature, labelHumidity]

        stackView = UIStackView(arrangedSubviews: array)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .white
        view.addSubview(stackView)
    }

}
