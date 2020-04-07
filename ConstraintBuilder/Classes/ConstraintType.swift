//
//  ConstraintType.swift
//  ConstraintBuilder
//
//  Created by brennobemoura on 07/04/20.
//

import Foundation
import UIKit

public protocol ConstraintType: ConstraintSearchable {}

extension ConstraintType {
    var constraints: [NSLayoutConstraint.Natural] {
        switch self {
        case let xRef as ConstraintX:
            return xRef.constraints
        case let yRef as ConstraintY:
            return yRef.constraints
        case let eRef as ConstraintEdges:
            return eRef.constraints
        case let dRef as ConstraintDimension:
            return dRef.constraints
        case let cRef as ConstraintCenter:
            return cRef.constraints
        default:
            fatalError()
        }
    }
}
