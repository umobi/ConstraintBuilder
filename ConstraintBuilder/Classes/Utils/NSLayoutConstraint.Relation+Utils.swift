//
//  NSLayoutConstraint.Relation+Utils.swift
//  ConstraintBuilder
//
//  Created by brennobemoura on 09/04/20.
//

import Foundation

extension NSLayoutConstraint.Relation {
    func invertIfNeeded(_ attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint.Relation {
        switch self {
        case .equal:
            return self
        case .lessThanOrEqual:
            return attribute.isNegative ? .greaterThanOrEqual : self
        case .greaterThanOrEqual:
            return attribute.isNegative ? .lessThanOrEqual : self
        @unknown default:
            return self
        }
    }
}
