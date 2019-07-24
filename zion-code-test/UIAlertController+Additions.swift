//
//  UIAlertController+Additions.swift
//  zion-code-test
//
//  Created by Pablo Epíscopo on 7/24/19.
//  Copyright © 2019 Pablo Epíscopo. All rights reserved.
//

import UIKit

public typealias AlertActionBlock = (UIAlertAction) -> Void

extension UIAlertController {

    class func locationErrorAlert(callHandler: AlertActionBlock?) -> UIAlertController {
        return alert("There was an error while getting your current location.", nil, "Ok", callHandler)
    }

    class func blockedFeatureAlert(_ blockedFeature: String) -> UIAlertController {
        let title = NSLocalizedString("\(Constants.Product.name) does not have access to your \(blockedFeature).", comment: "")
        let message = NSLocalizedString("Would you like to grant access?", comment: "")
        return alert(title, message, NSLocalizedString("Yes", comment: ""), { (UIAlertAction) in
            let url = URL(string: UIApplication.openSettingsURLString)
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }, NSLocalizedString("Not Now", comment: ""), nil)
    }

    // MARK: - private methods

    private class func alert(_ title: String?, _ message: String?, _ callTitle: String?, _ callHandler: AlertActionBlock?) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let callAction = UIAlertAction(title: callTitle == nil ? NSLocalizedString("OK", comment: "") : callTitle, style: .default, handler: callHandler)
        alertController.addAction(callAction)
        return alertController
    }

    private class func alert(_ title: String?, _ message: String?, _ callTitle: String, _ callHandler: AlertActionBlock?, _ cancelTitle: String, _ cancelHandler: AlertActionBlock?) -> UIAlertController {
        let alertController = UIAlertController(title: title ?? Constants.Product.name, message: message, preferredStyle: .alert)
        let callAction = UIAlertAction(title: callTitle, style: .default, handler: callHandler)
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler)
        alertController.addAction(callAction)
        alertController.addAction(cancelAction)
        return alertController
    }

}
