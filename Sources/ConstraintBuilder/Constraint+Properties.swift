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

public extension Constraint {
    @inlinable
    var equal: Self {
        self.edit {
            $0.relation = .equal
            $0.constant = nil
        }
    }

    @inlinable
    func equalTo(_ constant: CGFloat) -> Self {
        self.edit {
            $0.relation = .equal
            $0.constant = constant
        }
    }

    @inlinable
    func equalTo(_ reference: Constraint<Ref>) -> Self {
        self.edit {
            $0.relation = .equal
            $0.secondItem(ofFirstItem: reference)
            $0.secondAttribute(reference)
        }
    }

    @inlinable
    func equalTo(_ object: CBObject) -> Self {
        self.edit {
            $0.relation = .equal
            $0.secondItem = object
            $0.secondAttribute(self)
        }
    }
}

public extension Constraint {

    @inlinable
    var greaterThanOrEqual: Self {
        self.edit {
            $0.relation = .greaterThanOrEqual
            $0.constant = nil
        }
    }

    @inlinable
    func greaterThanOrEqualTo(_ constant: CGFloat) -> Self {
        self.edit {
            $0.relation = .greaterThanOrEqual
            $0.constant = constant
        }
    }

    @inlinable
    func greaterThanOrEqualTo(_ reference: Constraint<Ref>) -> Self {
        self.edit {
            $0.relation = .greaterThanOrEqual
            $0.secondItem(ofFirstItem: reference)
            $0.secondAttribute(reference)
        }
    }

    @inlinable
    func greaterThanOrEqualTo(_ object: CBObject) -> Self {
        self.edit {
            $0.relation = .greaterThanOrEqual
            $0.secondItem = object
            $0.secondAttribute(self)
        }
    }
}

public extension Constraint {

    @inlinable
    var lessThanOrEqual: Self {
        self.edit {
            $0.relation = .lessThanOrEqual
            $0.constant = nil
        }
    }

    @inlinable
    func lessThanOrEqualTo(_ constant: CGFloat) -> Self {
        self.edit {
            $0.relation = .lessThanOrEqual
            $0.constant = constant
        }
    }

    @inlinable
    func lessThanOrEqualTo(_ reference: Constraint<Ref>) -> Self {
        self.edit {
            $0.relation = .lessThanOrEqual
            $0.secondItem(ofFirstItem: reference)
            $0.secondAttribute(reference)
        }
    }

    @inlinable
    func lessThanOrEqualTo(_ object: CBObject) -> Self {
        self.edit {
            $0.relation = .lessThanOrEqual
            $0.secondItem = object
            $0.secondAttribute(self)
        }
    }
}

public extension Constraint {

    @inlinable
    func constant(_ constant: CGFloat) -> Self {
        self.edit {
            $0.constant = constant
        }
    }

    @inlinable
    func multiplier(_ multiplier: CGFloat) -> Self {
        self.edit {
            $0.multiplier = multiplier
        }
    }

    @inlinable
    func priority(_ priority: CBLayoutPriority) -> Self {
        self.edit {
            $0.priority = priority
        }
    }
}

public extension Constraint where Ref == ConstraintYReference {
    @inlinable
    var top: Self {
        self.edit {
            $0.firstAttribute.insert(.bottom)
        }
    }

    #if !os(macOS)
    @inlinable
    var topMargin: Self {
        self.edit {
            $0.firstAttribute.insert(.topMargin)
        }
    }
    #endif

    @inlinable
    var bottom: Self {
        self.edit {
            $0.firstAttribute.insert(.bottom)
        }
    }

    @inlinable
    var bottomMargin: Self {
        self.edit {
            $0.firstAttribute.insert(.bottom)
        }
    }
}

public extension Constraint where Ref == ConstraintXReference {
    @inlinable
    var leading: Self {
        self.edit {
            $0.firstAttribute.insert(.leading)
        }
    }

    #if !os(macOS)
    @inlinable
    var leadingMargin: Self {
        self.edit {
            $0.firstAttribute.insert(.leadingMargin)
        }
    }
    #endif

    @inlinable
    var left: Self {
        self.edit {
            $0.firstAttribute.insert(.left)
        }
    }

    #if !os(macOS)
    @inlinable
    var leftMargin: Self {
        self.edit {
            $0.firstAttribute.insert(.leftMargin)
        }
    }
    #endif
}

public extension Constraint where Ref == ConstraintXReference {
    @inlinable
    var trailing: Self {
        self.edit {
            $0.firstAttribute.insert(.trailing)
        }
    }

    #if !os(macOS)
    @inlinable
    var trailingMargin: Self {
        self.edit {
            $0.firstAttribute.insert(.trailingMargin)
        }
    }
    #endif

    @inlinable
    var right: Self {
        self.edit {
            $0.firstAttribute.insert(.right)
        }
    }

    #if !os(macOS)
    @inlinable
    var rightMargin: Self {
        self.edit {
            $0.firstAttribute.insert(.rightMargin)
        }
    }
    #endif
}

public extension Constraint where Ref == ConstraintCenterReference {
    @inlinable
    var centerY: Self {
        self.edit {
            $0.firstAttribute.insert(.centerY)
        }
    }

    #if !os(macOS)
    @inlinable
    var centerYWithinMargins: Self {
        self.edit {
            $0.firstAttribute.insert(.centerYWithinMargins)
        }
    }
    #endif

    @inlinable
    var centerX: Self {
        self.edit {
            $0.firstAttribute.insert(.centerX)
        }
    }

    #if !os(macOS)
    @inlinable
    var centerXWithinMargins: Self {
        self.edit {
            $0.firstAttribute.insert(.centerXWithinMargins)
        }
    }
    #endif
}

public extension Constraint where Ref == ConstraintDimensionReference {
    @inlinable
    var height: Self {
        self.edit {
            $0.firstAttribute.insert(.height)
        }
    }

    @inlinable
    var width: Self {
        self.edit {
            $0.firstAttribute.insert(.width)
        }
    }
}

public extension Constraint where Ref == ConstraintYReference {

    @inlinable
    var firstBaseline: Self {
        self.edit {
            $0.firstAttribute.insert(.firstBaseline)
        }
    }

    @inlinable
    var lastBaseline: Self {
        self.edit {
            $0.firstAttribute.insert(.lastBaseline)
        }
    }
}

public extension Constraint {
    @inlinable
    func isActive(_ isActive: Bool) -> Self {
        self.edit {
            $0.isActive = isActive
        }
    }
}
