import Foundation
import UIKit

public struct Constraint<Ref: ContraintReference>: ConstraintType {
    private let firstItem: NSObject
    private let secondItem: NSObject?
    private let firstAttribute: Set<NSLayoutConstraint.Attribute>
    private let relation: NSLayoutConstraint.Relation?
    private let secondAttribute: Set<NSLayoutConstraint.Attribute>
    private let priority: UILayoutPriority?
    private let constant: CGFloat?
    private let multiplier: CGFloat?

    internal init(_ firstItem: NSObject) {
        self.firstItem = firstItem
        self.secondItem = nil
        self.firstAttribute = []
        self.relation = nil
        self.secondAttribute = []
        self.priority = nil
        self.constant = nil
        self.multiplier = nil
    }

    fileprivate init(_ original: Constraint<Ref>, editable: Editable) {
        self.firstItem = original.firstItem
        self.secondItem = editable.secondItem
        self.firstAttribute = editable.firstAttribute
        self.relation = editable.relation
        self.secondAttribute = editable.secondAttribute
        self.priority = editable.priority
        self.constant = editable.constant
        self.multiplier = editable.multiplier
    }

    internal func firstAttribute(_ firstAttribute: NSLayoutConstraint.Attribute...) -> Self {
        self.edit {
            $0.firstAttribute = .init(firstAttribute)
        }
    }
}

public extension Constraint {
    func equalTo(_ constant: CGFloat) -> Self {
        self.edit {
            $0.relation = .equal
            $0.constant = constant
        }
    }

    func equalTo(_ reference: Constraint<Ref>) -> Self {
        self.edit {
            $0.relation = .equal
            $0.secondItem = reference.firstItem
            $0.secondAttribute(reference)
        }
    }

    func equalTo(_ object: NSObject) -> Self {
        self.edit {
            $0.relation = .equal
            $0.secondItem = object
            $0.secondAttribute(self)
        }
    }
}

public extension Constraint {

    func greaterThanOrEqualTo(_ constant: CGFloat) -> Self {
        self.edit {
            $0.relation = .greaterThanOrEqual
            $0.constant = constant
        }
    }

    func greaterThanOrEqualTo(_ reference: Constraint<Ref>) -> Self {
        self.edit {
            $0.relation = .greaterThanOrEqual
            $0.secondItem = reference.firstItem
            $0.secondAttribute(reference)
        }
    }

    func greaterThanOrEqualTo(_ object: NSObject) -> Self {
        self.edit {
            $0.relation = .greaterThanOrEqual
            $0.secondItem = object
            $0.secondAttribute(self)
        }
    }
}

public extension Constraint {

    func lessThanOrEqualTo(_ constant: CGFloat) -> Self {
        self.edit {
            $0.relation = .lessThanOrEqual
            $0.constant = constant
        }
    }

    func lessThanOrEqualTo(_ reference: Constraint<Ref>) -> Self {
        self.edit {
            $0.relation = .lessThanOrEqual
            $0.secondItem = reference.firstItem
            $0.secondAttribute(reference)
        }
    }

    func lessThanOrEqualTo(_ object: NSObject) -> Self {
        self.edit {
            $0.relation = .lessThanOrEqual
            $0.secondItem = object
            $0.secondAttribute(self)
        }
    }
}

public extension Constraint {

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
}

private extension Constraint {
    class Editable {
        var secondItem: NSObject?
        var firstAttribute: Set<NSLayoutConstraint.Attribute>
        var relation: NSLayoutConstraint.Relation?
        private(set) var secondAttribute: Set<NSLayoutConstraint.Attribute>
        var priority: UILayoutPriority?
        var constant: CGFloat?
        var multiplier: CGFloat?

        init(_ builder: Constraint<Ref>) {
            self.secondItem = builder.secondItem
            self.firstAttribute = builder.firstAttribute
            self.relation = builder.relation
            self.secondAttribute = builder.secondAttribute
            self.priority = builder.priority
            self.constant = builder.constant
            self.multiplier = builder.multiplier
        }

        func secondAttribute(_ reference: Constraint<Ref>) {
            if reference.firstAttribute.isEmpty {
                self.secondAttribute = self.firstAttribute
                return
            }

            if reference.firstAttribute.count == 1 {
                self.secondAttribute = reference.firstAttribute
                return
            }

            guard reference.firstAttribute == self.firstAttribute else {
                fatalError()
            }

            self.secondAttribute = reference.firstAttribute
        }
    }

    func edit(_ edit: @escaping (Editable) -> Void) -> Self {
        let editable = Editable(self)
        edit(editable)
        return .init(self, editable: editable)
    }
}

public extension Constraint where Ref == ConstraintYReference {
    var top: Self {
        self.edit {
            $0.firstAttribute.insert(.bottom)
        }
    }

    var topMargin: Self {
        self.edit {
            $0.firstAttribute.insert(.topMargin)
        }
    }

    var bottom: Self {
        self.edit {
            $0.firstAttribute.insert(.bottom)
        }
    }

    var bottomMargin: Self {
        self.edit {
            $0.firstAttribute.insert(.bottom)
        }
    }
}

public extension Constraint where Ref == ConstraintXReference {
    var leading: Self {
        self.edit {
            $0.firstAttribute.insert(.leading)
        }
    }

    var leadingMargin: Self {
        self.edit {
            $0.firstAttribute.insert(.leadingMargin)
        }
    }

    var left: Self {
        self.edit {
            $0.firstAttribute.insert(.left)
        }
    }

    var leftMargin: Self {
        self.edit {
            $0.firstAttribute.insert(.leftMargin)
        }
    }
}

public extension Constraint where Ref == ConstraintXReference {
    var trailing: Self {
        self.edit {
            $0.firstAttribute.insert(.trailing)
        }
    }

    var trailingMargin: Self {
        self.edit {
            $0.firstAttribute.insert(.trailingMargin)
        }
    }

    var right: Self {
        self.edit {
            $0.firstAttribute.insert(.right)
        }
    }

    var rightMargin: Self {
        self.edit {
            $0.firstAttribute.insert(.rightMargin)
        }
    }
}

public extension Constraint where Ref == ConstraintCenterReference {
    var centerY: Self {
        self.edit {
            $0.firstAttribute.insert(.centerY)
        }
    }

    var centerYWithinMargins: Self {
        self.edit {
            $0.firstAttribute.insert(.centerYWithinMargins)
        }
    }

    var centerX: Self {
        self.edit {
            $0.firstAttribute.insert(.centerX)
        }
    }

    var centerXWithinMargins: Self {
        self.edit {
            $0.firstAttribute.insert(.centerXWithinMargins)
        }
    }
}

public extension Constraint where Ref == ConstraintDimensionReference {
    var height: Self {
        self.edit {
            $0.firstAttribute.insert(.height)
        }
    }

    var width: Self {
        self.edit {
            $0.firstAttribute.insert(.width)
        }
    }
}

public extension Constraint where Ref == ConstraintYReference {

    var firstBaseline: Self {
        self.edit {
            $0.firstAttribute.insert(.firstBaseline)
        }
    }

    var lastBaseline: Self {
        self.edit {
            $0.firstAttribute.insert(.lastBaseline)
        }
    }
}

extension Constraint {
    var constraints: [NSLayoutConstraint] {
        return self.firstAttribute.map { firstAttribute in
            NSLayoutConstraint(
                item: self.firstItem,
                attribute: firstAttribute,
                relatedBy: self.relation ?? .equal,
                toItem: self.secondItem ?? firstAttribute.needsItem(self.firstItem),
                attribute: {
                    return ((self.secondAttribute.first(where: { $0 == firstAttribute }) ??
                        self.secondAttribute.first) ??
                        .notAnAttribute)
                }(),
                multiplier: self.multiplier ?? 1,
                constant: (firstAttribute.isNegative ? -1 : 1) * (self.constant ?? 0)
            )
        }
    }
}

private extension NSObject {
    var superUIItem: NSObject? {
        switch self {
        case let view as UIView:
            return view.superview
        case let guide as UILayoutGuide:
            return guide.owningView?.superview
        default:
            fatalError()
        }
    }
}

private extension NSLayoutConstraint.Attribute {
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
            return firstItem.superUIItem
        case .leading, .leadingMargin, .trailing, .trailingMargin:
            return firstItem.superUIItem
        case .left, .leftMargin, .right, .rightMargin:
            return firstItem.superUIItem
        case .lastBaseline, .firstBaseline:
            return firstItem.superUIItem
        case .centerX, .centerXWithinMargins, .centerY, .centerYWithinMargins:
            return firstItem.superUIItem
        case .height, .width, .notAnAttribute:
            return nil
        }
    }
}
