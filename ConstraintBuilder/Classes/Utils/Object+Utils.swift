//
//  Object+Utils.swift
//  ConstraintBuilder
//
//  Created by brennobemoura on 09/04/20.
//

import Foundation

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

extension NSObject {
    var uiSuperitem: NSObject? {
        switch self {
        case let view as UIView:
            return view.superview
        case let guide as UILayoutGuide:
            return guide.owningView?.superview
        default:
            fatalError()
        }
    }

    var uiConstraints: [NSLayoutConstraint] {
        switch self {
        case let view as UIView:
            return view.constraints
        case let guide as UILayoutGuide:
            return guide.owningView?.constraints.filter {
                $0.firstItem === guide || $0.secondItem === guide
            } ?? []
        default:
            fatalError()
        }
    }
}
