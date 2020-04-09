//
//  ConstraintUpdate.swift
//  ConstraintBuilder
//
//  Created by brennobemoura on 09/04/20.
//

import Foundation
import UIKit

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
