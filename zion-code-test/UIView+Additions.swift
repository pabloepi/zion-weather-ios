//
//  UIView+Additions.swift
//  zion-code-test
//
//  Created by Pablo Epíscopo on 7/24/19.
//  Copyright © 2019 Pablo Epíscopo. All rights reserved.
//

import UIKit

extension UIView {

    func toSuperviewBounds(constant: CGFloat?) {
        guard let superview = self.superview else {
            print("`superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superview.topAnchor, constant: constant ?? 0).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: constant ?? 0).isActive = true
        leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: constant ?? 0).isActive = true
        trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: constant ?? 0).isActive = true
    }

}
