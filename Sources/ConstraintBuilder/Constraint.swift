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
import CoreGraphics

public struct Constraint<Ref: ConstraintReference>: ConstraintType {
    private let firstItem: CBObject
    private let secondItem: CBObject?
    private let firstAttribute: Set<CBLayoutConstraint.Attribute>
    private let relation: CBLayoutConstraint.Relation?
    private let secondAttribute: Set<CBLayoutConstraint.Attribute>
    private let priority: CBLayoutPriority?
    private let constant: CGFloat?
    private let multiplier: CGFloat?

    internal init(_ firstItem: CBObject) {
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

    internal func firstAttribute(_ firstAttribute: CBLayoutConstraint.Attribute...) -> Self {
        self.edit {
            $0.firstAttribute = .init(firstAttribute)
        }
    }
}

public extension Constraint {
    func update() -> ConstraintUpdate<Ref> {
        .init(self)
    }
}

extension Constraint {
    var constraints: [CBLayoutConstraint.Natural] {
        return self.firstAttribute.map { firstAttribute in
            let secondItem = SecondItem(self, firstAttribute: firstAttribute)
            let constant: CGFloat? = {
                guard let constant = self.constant else {
                    return nil
                }

                return (firstAttribute.isNegative ? -1 : 1) * constant
            }()

            return CBLayoutConstraint.Natural(
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

internal extension Constraint {
    class Editable {
        var secondItem: CBObject?
        var firstAttribute: Set<CBLayoutConstraint.Attribute>
        var relation: CBLayoutConstraint.Relation?
        private(set) var secondAttribute: Set<CBLayoutConstraint.Attribute>
        var priority: CBLayoutPriority?
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

        func secondItem(ofFirstItem reference: Constraint<Ref>) {
            self.secondItem = reference.firstItem
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
        let item: CBObject
        let attribute: CBLayoutConstraint.Attribute

        init?(_ constraint: Constraint<Ref>, firstAttribute: CBLayoutConstraint.Attribute) {
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
