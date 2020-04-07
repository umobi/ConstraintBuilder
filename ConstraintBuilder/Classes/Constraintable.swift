//
//  Constraintable.swift
//  ConstraintBuilder
//
//  Created by brennobemoura on 07/04/20.
//

import Foundation
import UIKit

public struct Constraintable: ConstraintSearchable {
    fileprivate let firstItem: NSObject

    internal init(_ firstItem: NSObject) {
        self.firstItem = firstItem
    }
}

public extension Constraintable {
    var edges: ConstraintEdges {
        ConstraintEdges(self.firstItem)
            .firstAttribute(.top, .leading, .trailing, .bottom)
    }
}

public extension Constraintable {

    var top: ConstraintY {
        ConstraintY(self.firstItem)
            .firstAttribute(.top)
    }

    var topMargin: ConstraintY {
        ConstraintY(self.firstItem)
            .firstAttribute(.topMargin)
    }
}

public extension Constraintable {

    var bottom: ConstraintY {
        ConstraintY(self.firstItem)
            .firstAttribute(.bottom)
    }

    var bottomMargin: ConstraintY {
        ConstraintY(self.firstItem)
            .firstAttribute(.bottomMargin)
    }
}

public extension Constraintable {

    var leading: ConstraintX {
        ConstraintX(self.firstItem)
            .firstAttribute(.leading)
    }

    var leadingMargin: ConstraintX {
        ConstraintX(self.firstItem)
            .firstAttribute(.leadingMargin)
    }
}

public extension Constraintable {
    var left: ConstraintX {
        ConstraintX(self.firstItem)
            .firstAttribute(.left)
    }

    var leftMargin: ConstraintX {
        ConstraintX(self.firstItem)
            .firstAttribute(.leftMargin)
    }
}

public extension Constraintable {
    var trailing: ConstraintX {
        ConstraintX(self.firstItem)
            .firstAttribute(.trailing)
    }

    var trailingMargin: ConstraintX {
        ConstraintX(self.firstItem)
            .firstAttribute(.trailingMargin)
    }
}

public extension Constraintable {
    var right: ConstraintX {
        ConstraintX(self.firstItem)
            .firstAttribute(.right)
    }

    var rightMargin: ConstraintX {
        ConstraintX(self.firstItem)
            .firstAttribute(.rightMargin)
    }
}

public extension Constraintable {
    var centerX: ConstraintX {
        ConstraintX(self.firstItem)
            .firstAttribute(.centerX)
    }

    var centerXWithinMargins: ConstraintX {
        ConstraintX(self.firstItem)
            .firstAttribute(.centerXWithinMargins)
    }

    var centerY: ConstraintY {
        ConstraintY(self.firstItem)
            .firstAttribute(.centerY)
    }

    var centerYWithinMargins: ConstraintY {
        ConstraintY(self.firstItem)
            .firstAttribute(.centerYWithinMargins)
    }
}

public extension Constraintable {
    var center: ConstraintCenter {
        ConstraintCenter(self.firstItem)
            .firstAttribute(.centerX, .centerY)
    }

    var centerWithinMargins: ConstraintCenter {
        ConstraintCenter(self.firstItem)
            .firstAttribute(.centerXWithinMargins, .centerYWithinMargins)
    }
}

public extension Constraintable {
    var height: ConstraintDimension {
        ConstraintDimension(self.firstItem)
            .firstAttribute(.height)
    }

    var width: ConstraintDimension {
        ConstraintDimension(self.firstItem)
            .firstAttribute(.width)
    }
}

public extension Constraintable {

    var firstBaseline: ConstraintY {
        ConstraintY(self.firstItem)
            .firstAttribute(.firstBaseline)
    }

    var lastBaseline: ConstraintY {
        ConstraintY(self.firstItem)
            .firstAttribute(.lastBaseline)
    }
}

public extension Constraintable {
    static func activate(_ constraints: [ConstraintType]) {
        NSLayoutConstraint.activate(constraints.reduce([NSLayoutConstraint]()) {
            $0 + $1.constraints.map {
                $0.constraint
            }
        })
    }

    static func activate(_ constraints: ConstraintType...) {
        NSLayoutConstraint.activate(constraints.reduce([NSLayoutConstraint]()) {
            $0 + $1.constraints.map {
                $0.constraint
            }
        })
    }
}

public extension Constraintable {
    static func deactivate(_ constraints: [ConstraintSearchable]) {
        NSLayoutConstraint.deactivate(constraints.reduce([NSLayoutConstraint]()) {
            $0 + $1.constraints.reduce([NSLayoutConstraint]()) {
                $0 + $1.thatExists
            }
        })
    }

    static func deactivate(_ constraints: ConstraintSearchable...) {
        NSLayoutConstraint.deactivate(constraints.reduce([NSLayoutConstraint]()) {
            $0 + $1.constraints.reduce([NSLayoutConstraint]()) {
                $0 + $1.thatExists
            }
        })
    }
}

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

protocol GenericConstraint {
    var constraint: NSLayoutConstraint { get }
}

extension NSLayoutConstraint.Natural {
    var thatExists: [NSLayoutConstraint] {
        let secondItem = self.secondItem ?? self.firstItem.uiSuperitem
        let firstItemConstraints = self.firstItem.uiConstraints
        let secondItemConstraints = secondItem?.uiConstraints ?? []
        let mayBeNil = self.secondAttribute == nil || self.secondAttribute == .notAnAttribute

        let constraints = firstItemConstraints + secondItemConstraints

        return constraints.filter {
            let check = [Bool]([
                secondItem == nil || secondItem === $0.secondItem || (mayBeNil && $0.secondItem == nil),
                self.firstAttribute == $0.firstAttribute,
                self.secondAttribute == nil || self.secondAttribute == $0.secondAttribute,
                self.relation == nil || self.relation == $0.relation,
                self.priority == nil || self.priority == $0.priority,
                self.constant == nil || self.constant == $0.constant,
                self.multiplier == nil || self.multiplier == self.multiplier
            ])

            return check.allSatisfy { $0 }
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


public protocol ConstraintSearchable {

}

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
