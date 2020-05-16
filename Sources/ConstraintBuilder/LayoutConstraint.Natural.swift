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

extension CBLayoutConstraint {
    struct Natural: GenericConstraint {
        let firstItem: CBObject
        let secondItem: CBObject?
        let firstAttribute: CBLayoutConstraint.Attribute
        let relation: CBLayoutConstraint.Relation?
        let secondAttribute: CBLayoutConstraint.Attribute?
        let priority: CBLayoutPriority?
        let constant: CGFloat?
        let multiplier: CGFloat?
        let isActive: Bool?

        var constraint: CBLayoutConstraint {
            let constraint = CBLayoutConstraint(
                item: self.firstItem,
                attribute: self.firstAttribute,
                relatedBy: self.relation ?? .equal,
                toItem: self.secondItem,
                attribute: self.secondAttribute ?? .notAnAttribute,
                multiplier: self.multiplier ?? 1,
                constant: self.constant ?? 0
            )

            constraint.priority = self.priority ?? .required
            constraint.isActive = self.isActive ?? true
            return constraint
        }
    }
}

extension CBLayoutConstraint {
    var natural: Natural? {
        guard let firstItem = self.firstItem as? CBObject, self.firstAttribute.isValid else {
            return nil
        }

        return Natural(
            firstItem: firstItem,
            secondItem: self.secondItem as? CBObject,
            firstAttribute: self.firstAttribute,
            relation: self.relation,
            secondAttribute: self.secondAttribute,
            priority: self.priority,
            constant: self.constant,
            multiplier: self.multiplier,
            isActive: self.isActive
        )
    }
}

extension CBLayoutConstraint.Natural {
    var thatExists: [CBLayoutConstraint] {
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
    var constraints: [CBLayoutConstraint.Natural] {
        (self.firstItem.uiConstraints + (self.firstItem.uiSuperitem?.uiConstraints ?? []))
            .filter { $0.firstItem === self.firstItem }
            .compactMap { $0.natural }
    }
}
