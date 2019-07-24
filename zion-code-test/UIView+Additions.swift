//
//  UIView+Additions.swift
//  zion-code-test
//
//  Created by Pablo Epíscopo on 7/24/19.
//  Copyright © 2019 Pablo Epíscopo. All rights reserved.
//

import UIKit

extension UIView {

    func toSuperviewBounds() {
        toSuperviewBounds(topAnchorConstant: 0.0, bottomAnchorConstant: 0.0, leadingAnchorConstant: 0.0, trailingAnchorConstant: 0.0)
    }

    func toSuperviewBounds(topAnchorConstant: CGFloat, bottomAnchorConstant: CGFloat, leadingAnchorConstant: CGFloat, trailingAnchorConstant: CGFloat) {
        guard let superview = self.superview else {
            print("`superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superview.topAnchor, constant: topAnchorConstant).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: bottomAnchorConstant).isActive = true
        leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leadingAnchorConstant).isActive = true
        trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: trailingAnchorConstant).isActive = true
    }

}
