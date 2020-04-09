//
//  ConstraintSearchable.swift
//  ConstraintBuilder
//
//  Created by brennobemoura on 09/04/20.
//

import Foundation
import UIKit

public protocol ConstraintSearchable {}

extension ConstraintSearchable {
    var constraints: [NSLayoutConstraint.Natural] {
        switch self {
        case let constraintType as ConstraintType:
            return constraintType.constraints
        case let contraintable as Constraintable:
            return contraintable.constraints
        default:
            return []
        }
    }
}

extension Constraintable {
    var searchableConstraints: [NSLayoutConstraint.Natural] {
        self.firstItem.uiConstraints.compactMap {
            $0.natural
        }
    }
}
