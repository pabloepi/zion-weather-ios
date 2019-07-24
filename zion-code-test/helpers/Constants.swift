//
//  Constants.swift
//  zion-code-test
//
//  Created by Pablo Epíscopo on 7/24/19.
//  Copyright © 2019 Pablo Epíscopo. All rights reserved.
//

import Foundation

typealias Dictionary = [String : Any]

typealias CompletionBlock = () -> Void
typealias ErrorCompletionBlock = (_ error: Error?) -> Void

struct Constants {

    struct Product {
        static let name = "Zion"
    }

}
