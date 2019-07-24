//
//  CustomError.swift
//  zion-code-test
//
//  Created by Pablo Epíscopo on 7/24/19.
//  Copyright © 2019 Pablo Epíscopo. All rights reserved.
//

import Foundation

enum CustomError: Error {

    case emptyResponse

    var userInfo: Dictionary? {
        switch self {
        case .emptyResponse: return nil
        }
    }

    var containsErrorKey: Bool {
        switch self {
        default: return false
        }
    }
}
