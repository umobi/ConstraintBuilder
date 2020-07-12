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

public struct Constraintable: ConstraintSearchable {
    internal let firstItem: CBObject

    internal init(_ firstItem: CBObject) {
        self.firstItem = firstItem
    }
}

public extension Constraintable {
    var edges: ConstraintEdges {
        ConstraintEdges(self.firstItem)
            .firstAttribute(.top, .leading, .trailing, .bottom)
    }
}

public extension Constraintable {

    var top: ConstraintY {
        ConstraintY(self.firstItem)
            .firstAttribute(.top)
    }

    #if !os(macOS)
    var topMargin: ConstraintY {
        ConstraintY(self.firstItem)
            .firstAttribute(.topMargin)
    }
    #endif
}

public extension Constraintable {

    var bottom: ConstraintY {
        ConstraintY(self.firstItem)
            .firstAttribute(.bottom)
    }

    #if !os(macOS)
    var bottomMargin: ConstraintY {
        ConstraintY(self.firstItem)
            .firstAttribute(.bottomMargin)
    }
    #endif
}

public extension Constraintable {

    var leading: ConstraintX {
        ConstraintX(self.firstItem)
            .firstAttribute(.leading)
    }

    #if !os(macOS)
    var leadingMargin: ConstraintX {
        ConstraintX(self.firstItem)
            .firstAttribute(.leadingMargin)
    }
    #endif
}

public extension Constraintable {
    var left: ConstraintX {
        ConstraintX(self.firstItem)
            .firstAttribute(.left)
    }

    #if !os(macOS)
    var leftMargin: ConstraintX {
        ConstraintX(self.firstItem)
            .firstAttribute(.leftMargin)
    }
    #endif
}

public extension Constraintable {
    var trailing: ConstraintX {
        ConstraintX(self.firstItem)
            .firstAttribute(.trailing)
    }

    #if !os(macOS)
    var trailingMargin: ConstraintX {
        ConstraintX(self.firstItem)
            .firstAttribute(.trailingMargin)
    }
    #endif
}

public extension Constraintable {
    var right: ConstraintX {
        ConstraintX(self.firstItem)
            .firstAttribute(.right)
    }

    #if !os(macOS)
    var rightMargin: ConstraintX {
        ConstraintX(self.firstItem)
            .firstAttribute(.rightMargin)
    }
    #endif
}

public extension Constraintable {
    var centerX: ConstraintX {
        ConstraintX(self.firstItem)
            .firstAttribute(.centerX)
    }

    #if !os(macOS)
    var centerXWithinMargins: ConstraintX {
        ConstraintX(self.firstItem)
            .firstAttribute(.centerXWithinMargins)
    }
    #endif

    var centerY: ConstraintY {
        ConstraintY(self.firstItem)
            .firstAttribute(.centerY)
    }

    #if !os(macOS)
    var centerYWithinMargins: ConstraintY {
        ConstraintY(self.firstItem)
            .firstAttribute(.centerYWithinMargins)
    }
    #endif
}

public extension Constraintable {
    var center: ConstraintCenter {
        ConstraintCenter(self.firstItem)
            .firstAttribute(.centerX, .centerY)
    }

    #if !os(macOS)
    var centerWithinMargins: ConstraintCenter {
        ConstraintCenter(self.firstItem)
            .firstAttribute(.centerXWithinMargins, .centerYWithinMargins)
    }
    #endif
}

public extension Constraintable {
    var height: ConstraintDimension {
        ConstraintDimension(self.firstItem)
            .firstAttribute(.height)
    }

    var width: ConstraintDimension {
        ConstraintDimension(self.firstItem)
            .firstAttribute(.width)
    }
}

public extension Constraintable {

    var firstBaseline: ConstraintY {
        ConstraintY(self.firstItem)
            .firstAttribute(.firstBaseline)
    }

    var lastBaseline: ConstraintY {
        ConstraintY(self.firstItem)
            .firstAttribute(.lastBaseline)
    }
}

public extension Constraintable {
    static func activate(_ constraints: [ConstraintType]) {
        CBLayoutConstraint.activate(constraints.reduce([CBLayoutConstraint]()) {
            $0 + $1.constraints.map {
                $0.constraint
            }
        })
    }

    static func activate(@ConstraintableBuilder _ constraints: () -> ConstraintType) {
        self.activate(constraints().zip)
    }
}

public extension Constraintable {
    static func deactivate(_ constraints: [ConstraintSearchable]) {
        CBLayoutConstraint.deactivate(constraints.reduce([CBLayoutConstraint]()) {
            $0 + $1.constraints.reduce([CBLayoutConstraint]()) {
                $0 + $1.thatExists
            }
        })
    }

    static func deactivate(@ConstraintSearchableBuilder _ constraints: () -> ConstraintSearchable) {
        self.deactivate(constraints().zip)
    }
}

public extension Constraintable {
    static func update(_ constraints: [ConstraintUpdatable]) {
        var toDelete: [CBLayoutConstraint] = []
        var toCreate: [ConstraintType] = []

        constraints.forEach {
            if let constraint = $0.constraintToDeactivate {
                toDelete.append(constraint)
            }

            if $0.updateConstraintIfNeeded() {
                return
            }

            toCreate.append($0.build)
        }

        CBLayoutConstraint.deactivate(toDelete)
        self.activate(toCreate)
    }

    static func update(@ConstraintUpdatableBuilder _ constraints: () -> ConstraintUpdatable) {
        self.update(constraints().zip)
    }
}
