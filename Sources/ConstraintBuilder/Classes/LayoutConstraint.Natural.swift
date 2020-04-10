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
