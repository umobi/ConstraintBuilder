//
//  NSLayoutConstraint.Natural.swift
//  ConstraintBuilder
//
//  Created by brennobemoura on 09/04/20.
//

import Foundation
import UIKit

extension NSLayoutConstraint {
    struct Natural: GenericConstraint {
        let firstItem: NSObject
        let secondItem: NSObject?
        let firstAttribute: NSLayoutConstraint.Attribute
        let relation: NSLayoutConstraint.Relation?
        let secondAttribute: NSLayoutConstraint.Attribute?
        let priority: UILayoutPriority?
        let constant: CGFloat?
        let multiplier: CGFloat?

        var constraint: NSLayoutConstraint {
            let constraint = NSLayoutConstraint(
                item: self.firstItem,
                attribute: self.firstAttribute,
                relatedBy: self.relation ?? .equal,
                toItem: self.secondItem,
                attribute: self.secondAttribute ?? .notAnAttribute,
                multiplier: self.multiplier ?? 1,
                constant: self.constant ?? 0
            )

            constraint.priority = self.priority ?? .required
            return constraint
        }
    }
}

extension NSLayoutConstraint {
    var natural: Natural? {
        guard let firstItem = self.firstItem as? NSObject, self.firstAttribute.isValid else {
            return nil
        }

        return Natural(
            firstItem: firstItem,
            secondItem: self.secondItem as? NSObject,
            firstAttribute: self.firstAttribute,
            relation: self.relation,
            secondAttribute: self.secondAttribute,
            priority: self.priority,
            constant: self.constant,
            multiplier: self.multiplier
        )
    }
}

extension NSLayoutConstraint.Natural {
    var thatExists: [NSLayoutConstraint] {
        let secondItem = self.secondItem ?? self.firstItem.uiSuperitem
        let firstItemConstraints = self.firstItem.uiConstraints
        let secondItemConstraints = secondItem?.uiConstraints ?? []

        let constraints = firstItemConstraints + secondItemConstraints

        return constraints.filter {
            $0.isEqual(self)
        }
    }
}

extension Constraintable {
    var constraints: [NSLayoutConstraint.Natural] {
        (self.firstItem.uiConstraints + (self.firstItem.uiSuperitem?.uiConstraints ?? []))
            .filter { $0.firstItem === self.firstItem }
            .compactMap { $0.natural }
    }
}
