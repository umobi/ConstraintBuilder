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
public struct ConstraintSearchableBuilder {
    @inline(__always) @inlinable
    static public func buildBlock(_ segments: ConstraintSearchable...) -> ConstraintSearchable {
        CombinedSearchs(children: segments)
    }
}

@usableFromInline
internal struct CombinedSearchs: ConstraintSearchable {
    let children: [ConstraintSearchable]

    @inline(__always) @usableFromInline
    init(children: [ConstraintSearchable]) {
        self.children = children
    }
}

internal extension ConstraintSearchable {
    @usableFromInline
    var zip: [ConstraintSearchable] {
        switch self {
        case let views as CombinedSearchs:
            return views.children
        default:
            return [self]
        }
    }
}

public protocol ConstraintSearchable {}

extension ConstraintSearchable {
    @usableFromInline
    var constraints: [CBLayoutConstraint.Natural] {
        switch self {
        case let constraintType as ConstraintType:
            return constraintType.constraints
        case let contraintable as Constraintable:
            return contraintable.constraints
        default:
            return []
        }
    }
}

extension Constraintable {
    @usableFromInline
    var searchableConstraints: [CBLayoutConstraint.Natural] {
        self.firstItem.uiConstraints.compactMap {
            $0.natural
        }
    }
}
