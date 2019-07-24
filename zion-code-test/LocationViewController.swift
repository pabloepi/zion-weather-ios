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
        stackView.toSuperviewBounds(topAnchorConstant: 24.0, bottomAnchorConstant: -view.bounds.height/2, leadingAnchorConstant: 24.0, trailingAnchorConstant: -24.0)
        super.updateViewConstraints()
    }

    // MARK: - private methods

    private func initGUI() {
        title = NSLocalizedString("Weather", comment: "")
        view.backgroundColor = .white

        let font = UIFont.systemFont(ofSize: 34, weight: UIFont.Weight.semibold)
        let labelDescription = UILabel()
        let labelTemperature = UILabel()
        let labelHumidity = UILabel()
        labelDescription.font = font
        labelTemperature.font = font
        labelHumidity.font = font
        labelDescription.text = location.weather.description
        labelTemperature.text = location.weather.temp
        labelHumidity.text = location.weather.humidity != nil ? "\(location.weather.humidity!) %" : "No humidity"
        let array = [labelDescription, labelTemperature, labelHumidity]

        stackView = UIStackView(arrangedSubviews: array)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .white
        view.addSubview(stackView)
    }

}
