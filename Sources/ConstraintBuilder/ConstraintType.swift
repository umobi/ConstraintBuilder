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

@_functionBuilder @frozen
public struct ConstraintableBuilder {
    @inline(__always) @inlinable
    static public func buildBlock(_ segments: ConstraintType...) -> ConstraintType {
        CombinedConstraintables(children: segments)
    }
}

@usableFromInline
internal struct CombinedConstraintables: ConstraintType {
    let children: [ConstraintType]

    @inline(__always) @usableFromInline
    init(children: [ConstraintType]) {
        self.children = children
    }
}

internal extension ConstraintType {
    @usableFromInline
    var zip: [ConstraintType] {
        switch self {
        case let views as CombinedConstraintables:
            return views.children
        default:
            return [self]
        }
    }
}

public protocol ConstraintType: ConstraintSearchable {}

extension ConstraintType {
    @usableFromInline
    var constraints: [CBLayoutConstraint.Natural] {
        switch self {
        case let xRef as ConstraintX:
            return xRef.constraints
        case let yRef as ConstraintY:
            return yRef.constraints
        case let eRef as ConstraintEdges:
            return eRef.constraints
        case let dRef as ConstraintDimension:
            return dRef.constraints
        case let cRef as ConstraintCenter:
            return cRef.constraints
        default:
            fatalError()
        }
    }
}
