//
//  ConstraintUpdatable.swift
//  ConstraintBuilder
//
//  Created by brennobemoura on 09/04/20.
//

import Foundation
import UIKit

public protocol ConstraintUpdatable {}

extension ConstraintUpdatable {

    var constraintToDeactivate: NSLayoutConstraint? {
        switch self {
        case let xRef as ConstraintUpdate<ConstraintXReference>:
            return xRef.constraintToDeactivate
        case let yRef as ConstraintUpdate<ConstraintYReference>:
            return yRef.constraintToDeactivate
        case let eRef as ConstraintUpdate<ConstraintEdgesReference>:
            return eRef.constraintToDeactivate
        case let dRef as ConstraintUpdate<ConstraintDimensionReference>:
            return dRef.constraintToDeactivate
        case let cRef as ConstraintUpdate<ConstraintCenterReference>:
            return cRef.constraintToDeactivate
        default:
            fatalError()
        }
    }

    var build: ConstraintType {
        switch self {
        case let xRef as ConstraintUpdate<ConstraintXReference>:
            return xRef.build
        case let yRef as ConstraintUpdate<ConstraintYReference>:
            return yRef.build
        case let eRef as ConstraintUpdate<ConstraintEdgesReference>:
            return eRef.build
        case let dRef as ConstraintUpdate<ConstraintDimensionReference>:
            return dRef.build
        case let cRef as ConstraintUpdate<ConstraintCenterReference>:
            return cRef.build
        default:
            fatalError()
        }
    }

    func updateConstraintIfNeeded() -> Bool {
        switch self {
        case let xRef as ConstraintUpdate<ConstraintXReference>:
            return xRef.updateConstraintIfNeeded()
        case let yRef as ConstraintUpdate<ConstraintYReference>:
            return yRef.updateConstraintIfNeeded()
        case let eRef as ConstraintUpdate<ConstraintEdgesReference>:
            return eRef.updateConstraintIfNeeded()
        case let dRef as ConstraintUpdate<ConstraintDimensionReference>:
            return dRef.updateConstraintIfNeeded()
        case let cRef as ConstraintUpdate<ConstraintCenterReference>:
            return cRef.updateConstraintIfNeeded()
        default:
            fatalError()
        }
    }
}
