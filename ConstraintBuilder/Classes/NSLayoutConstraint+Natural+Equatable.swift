//
//  NSLayoutConstraint+Natural+Equatable.swift
//  ConstraintBuilder
//
//  Created by brennobemoura on 09/04/20.
//

import Foundation
import UIKit

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
