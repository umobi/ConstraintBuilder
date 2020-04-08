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

extension NSLayoutConstraint {
    enum ItemOrder {
        case firstFirst
        case secondFirst
        case firstSecond
        case secondSecond
        case none
    }

    private func isFirstItemEqual(_ natural: Natural) -> ItemOrder {
        if natural.firstItem.isUIEqual(to: self.firstItem) {
            return .firstFirst
        }

        if natural.firstItem.isUIEqual(to: self.secondItem) {
            return .firstSecond
        }

        if natural.secondItem?.isUIEqual(to: self.firstItem) ?? false {
            return .secondFirst
        }

        if natural.secondItem?.isUIEqual(to: self.secondItem) ?? false {
            return .secondSecond
        }

        return .none
    }

    private func isSecondItemEqual(_ natural: Natural, with order: ItemOrder) -> Bool {
        switch order {
        case .firstFirst:
            guard let secondItem = natural.secondItem else {
                return self.secondItem == nil
            }

            return secondItem.isUIEqual(to: self.secondItem)
        case .firstSecond:
            guard let secondItem = natural.secondItem else {
                return false
            }

            return secondItem.isUIEqual(to: self.firstItem)
        case .secondFirst:
            return natural.firstItem.isUIEqual(to: self.secondItem)
        case .secondSecond:
            return natural.firstItem.isUIEqual(to: self.firstItem)
        case .none:
            return false
        }
    }

    private func isFirstAttributeEqual(_ natural: Natural, with order: ItemOrder) -> Bool {
        switch order {
        case .firstFirst:
            return natural.firstAttribute.isEqual(to: self.firstAttribute)
        case .firstSecond:
            return natural.firstAttribute.isEqual(to: self.secondAttribute)
        case .secondFirst:
            guard let secondAttribute = natural.secondAttribute else {
                return self.firstAttribute == .notAnAttribute
            }

            return secondAttribute.isEqual(to: self.firstAttribute)
        case .secondSecond:
            guard let secondAttribute = natural.secondAttribute else {
                return self.secondAttribute == .notAnAttribute
            }

            return secondAttribute.isEqual(to: self.secondAttribute)
        case .none:
            return false
        }
    }

    private func isSecondAttributeEqual(_ natural: Natural, with order: ItemOrder) -> Bool {
        switch order {
        case .firstFirst:
            guard let secondAttribute = natural.secondAttribute else {
                return self.secondAttribute == .notAnAttribute
            }

            return secondAttribute.isEqual(to: self.secondAttribute)
        case .firstSecond:
            guard let secondAttribute = natural.secondAttribute else {
                return self.firstAttribute == .notAnAttribute
            }

            return secondAttribute.isEqual(to: self.firstAttribute)
        case .secondFirst:
            return natural.firstAttribute.isEqual(to: self.secondAttribute)
        case .secondSecond:
            return natural.firstAttribute.isEqual(to: self.firstAttribute)
        case .none:
            return false
        }
    }

    func isEqual(_ natural: Natural) -> Bool {
        let order = self.isFirstItemEqual(natural)

        if case .none = order {
            return false
        }

        guard self.isSecondItemEqual(natural, with: order) else {
            return false
        }

        guard self.isFirstAttributeEqual(natural, with: order) else {
            return false
        }

        guard self.isSecondItemEqual(natural, with: order) else {
            return false
        }

        if let relation = natural.relation, self.relation != relation {
            return false
        }

        if let priority = natural.priority, self.priority != priority {
            return false
        }

        if let constant = natural.constant, self.constant != constant {
            return false
        }

        if let multiplier = natural.multiplier, self.multiplier != multiplier {
            return false
        }

        return true
    }
}

protocol GenericConstraint {
    var constraint: NSLayoutConstraint { get }
}

extension NSLayoutConstraint.Attribute {
    func isEqual(to attribute: NSLayoutConstraint.Attribute) -> Bool {
        switch self {
        case .leading, .left:
            return [.leading, .left].contains(attribute)
        case .leadingMargin, .leftMargin:
            return [.leadingMargin, .leftMargin].contains(attribute)
        case .trailing, .right:
            return [.trailing, .right].contains(attribute)
        case .trailingMargin, .rightMargin:
            return [.trailingMargin, .rightMargin].contains(attribute)
        default:
            return self == attribute
        }
    }
}

extension NSObject {
    func isUIEqual(to object: AnyObject?) -> Bool {
        if let view = self as? UIView {
            if let guide = object as? UILayoutGuide {
                return view === guide.owningView
            }
        }

        if let guide = self as? UILayoutGuide {
            if let view = object as? UIView {
                return guide.owningView === view
            }
        }

        return self === object
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

public protocol ConstraintUpdatable {

}

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

public struct ConstraintUpdate<Ref: ConstraintReference>: ConstraintUpdatable {
    private let constraintBuilder: Constraint<Ref>
    private let constant: CGFloat?
    private let priority: UILayoutPriority?
    private let multiplier: CGFloat?
    private let isActive: Bool?

    init(_ constraintBuilder: Constraint<Ref>) {
        self.constraintBuilder = constraintBuilder
        self.constant = nil
        self.priority = nil
        self.multiplier = nil
        self.isActive = nil
    }

    private init(_ original: ConstraintUpdate, editable: Editable) {
        self.constraintBuilder = original.constraintBuilder
        self.constant = editable.constant
        self.priority = editable.priority
        self.multiplier = editable.multiplier
        self.isActive = editable.isActive
    }

    func edit(_ edit: @escaping (Editable) -> Void) -> Self {
        let editable = Editable(self)
        edit(editable)
        return .init(self, editable: editable)
    }

    class Editable {
        var constant: CGFloat?
        var priority: UILayoutPriority?
        var multiplier: CGFloat?
        var isActive: Bool?

        init(_ update: ConstraintUpdate) {
            self.constant = update.constant
            self.priority = update.priority
            self.multiplier = update.multiplier
            self.isActive = update.isActive
        }
    }

    private var needsToDeleteConstraint: Bool {
        if #available(iOS 13, tvOS 13, *) {
            return self.multiplier != nil
        }

        return self.multiplier != nil && self.priority != nil
    }

    var constraintToDeactivate: NSLayoutConstraint? {
        guard self.needsToDeleteConstraint else {
            return nil
        }

        let constraints = self.constraintBuilder.constraints
        guard constraints.count == 1 else {
            fatalError()
        }

        guard let constraint = constraints.first?.thatExists.first else {
            return nil
        }

        if #available(iOS 13, tvOS 13, *) {
            return self.multiplier != nil && self.multiplier != constraint.multiplier ? constraint : nil
        }

        return (self.multiplier != nil && self.multiplier != constraint.multiplier) || (self.priority != nil && self.priority != constraint.priority) ? constraint : nil
    }

    func updateConstraintIfNeeded() -> Bool {
        guard !self.needsToDeleteConstraint else {
            return false
        }

        let constraints = self.constraintBuilder.constraints
        guard constraints.count == 1, let toUpdateConstraint = self.build.constraints.first else {
            fatalError()
        }

        guard let constraint = constraints.first?.thatExists.first else {
            return !(self.isActive ?? true)
        }

        constraint.constant = toUpdateConstraint.constant ?? constraint.constant
        constraint.priority = toUpdateConstraint.priority ?? constraint.priority
        constraint.isActive = self.isActive ?? true

        return true
    }

    var build: Constraint<Ref> {
        var builder = self.constraintBuilder
        if let priority = self.priority {
            builder = builder.priority(priority)
        }

        if let constant = self.constant {
            builder = builder.constant(constant)
        }

        if let multiplier = self.multiplier {
            builder = builder.multiplier(multiplier)
        }

        return builder
    }
}

public extension ConstraintUpdate {
    func constant(_ constant: CGFloat) -> Self {
        self.edit {
            $0.constant = constant
        }
    }

    func multiplier(_ multiplier: CGFloat) -> Self {
        self.edit {
            $0.multiplier = multiplier
        }
    }

    func priority(_ priority: UILayoutPriority) -> Self {
        self.edit {
            $0.priority = priority
        }
    }

    func isActive(_ flag: Bool) -> Self {
        self.edit {
            $0.isActive = flag
        }
    }
}

public extension Constraintable {
    static func update(_ constraints: [ConstraintUpdatable]) {
        var toDelete: [NSLayoutConstraint] = []
        var toCreate: [ConstraintType] = []

        constraints.forEach {
            if let constraint = $0.constraintToDeactivate {
                toDelete.append(constraint)
            }

            if $0.updateConstraintIfNeeded() {
                return
            }

            toCreate.append($0.build)
        }

        NSLayoutConstraint.deactivate(toDelete)
        self.activate(toCreate)
    }
//
    static func update(_ constraints: ConstraintUpdatable...) {
        self.update(constraints)
    }
}
