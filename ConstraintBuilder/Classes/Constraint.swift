//
// Copyright (c) 2020-Present Umobi - https://github.com/umobi
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import Foundation
import UIKit

public struct Constraint<Ref: ConstraintReference>: ConstraintType {
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

public extension Constraint {
    func update() -> ConstraintUpdate<Ref> {
        .init(self)
    }
}

extension Constraint {
    var constraints: [NSLayoutConstraint.Natural] {
        return self.firstAttribute.map { firstAttribute in
            let secondItem = SecondItem(self, firstAttribute: firstAttribute)
            let constant: CGFloat? = {
                guard let constant = self.constant else {
                    return nil
                }

                return (firstAttribute.isNegative ? -1 : 1) * constant
            }()

            return NSLayoutConstraint.Natural(
                firstItem: self.firstItem,
                secondItem: secondItem?.item,
                firstAttribute: firstAttribute,
                relation: self.relation?.invertIfNeeded(firstAttribute),
                secondAttribute: secondItem?.attribute,
                priority: self.priority,
                constant: constant,
                multiplier: self.multiplier
            )
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

            guard reference.firstAttribute.count == self.firstAttribute.count && (reference.firstAttribute.allSatisfy {
                self.firstAttribute.contains($0)
            }) else {
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

extension Constraint {
    struct SecondItem {
        let item: NSObject
        let attribute: NSLayoutConstraint.Attribute

        init?(_ constraint: Constraint<Ref>, firstAttribute: NSLayoutConstraint.Attribute) {
            guard let item = constraint.secondItem ?? firstAttribute.needsItem(constraint.firstItem) else {
                return nil
            }

            self.item = item
            self.attribute = {
                if let attribute = constraint.secondAttribute.first(where: { $0 == firstAttribute }) {
                    return attribute
                }

                if let attribute = constraint.secondAttribute.first {
                    return attribute
                }

                return firstAttribute
            }()
        }
    }
}
