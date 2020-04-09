//
//  NSLayoutConstraint.Attribute+Utils.swift
//  ConstraintBuilder
//
//  Created by brennobemoura on 09/04/20.
//

import Foundation
import UIKit

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

extension NSLayoutConstraint.Attribute {
    var isValid: Bool {
        switch self {
        case .top, .topMargin, .bottom, .bottomMargin, .leading, .leadingMargin, .trailing, .trailingMargin, .left, .leftMargin, .right, .rightMargin, .lastBaseline, .firstBaseline, .centerX, .centerXWithinMargins, .centerY, .centerYWithinMargins, .height, .width, .notAnAttribute:
            return true
        @unknown default:
            return false
        }
    }
}

extension NSLayoutConstraint.Attribute {
    var isNegative: Bool {
        switch self {
        case .bottom, .bottomMargin, .trailing, .trailingMargin, .right, .rightMargin:
            return true
        case .centerY, .centerYWithinMargins, .lastBaseline:
            return true
        default:
            return false
        }
    }

    func needsItem(_ firstItem: NSObject) -> NSObject? {
        switch self {
        case .top, .topMargin, .bottom, .bottomMargin:
            return firstItem.uiSuperitem
        case .leading, .leadingMargin, .trailing, .trailingMargin:
            return firstItem.uiSuperitem
        case .left, .leftMargin, .right, .rightMargin:
            return firstItem.uiSuperitem
        case .lastBaseline, .firstBaseline:
            return firstItem.uiSuperitem
        case .centerX, .centerXWithinMargins, .centerY, .centerYWithinMargins:
            return firstItem.uiSuperitem
        case .height, .width, .notAnAttribute:
            return nil
        @unknown default:
            return nil
        }
    }
}
