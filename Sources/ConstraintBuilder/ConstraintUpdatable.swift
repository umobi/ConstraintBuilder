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

public protocol ConstraintUpdatable {}

extension ConstraintUpdatable {

    var constraintToDeactivate: CBLayoutConstraint? {
        switch self {
        case let xRef as ConstraintUpdate<ConstraintXReference>:
            return xRef.constraintToDeactivate
        case let yRef as ConstraintUpdate<ConstraintYReference>:
            return yRef.constraintToDeactivate
        case let eRef as ConstraintUpdate<ConstraintEdgesReference>:
            return eRef.constraintToDeactivate
        case let dRef as ConstraintUpdate<ConstraintDimensionReference>:
            return dRef.constraintToDeactivate
        case let cRef as ConstraintUpdate<ConstraintCenterReference>:
            return cRef.constraintToDeactivate
        default:
            fatalError()
        }
    }

    var build: ConstraintType {
        switch self {
        case let xRef as ConstraintUpdate<ConstraintXReference>:
            return xRef.build
        case let yRef as ConstraintUpdate<ConstraintYReference>:
            return yRef.build
        case let eRef as ConstraintUpdate<ConstraintEdgesReference>:
            return eRef.build
        case let dRef as ConstraintUpdate<ConstraintDimensionReference>:
            return dRef.build
        case let cRef as ConstraintUpdate<ConstraintCenterReference>:
            return cRef.build
        default:
            fatalError()
        }
    }

    func updateConstraintIfNeeded() -> Bool {
        switch self {
        case let xRef as ConstraintUpdate<ConstraintXReference>:
            return xRef.updateConstraintIfNeeded()
        case let yRef as ConstraintUpdate<ConstraintYReference>:
            return yRef.updateConstraintIfNeeded()
        case let eRef as ConstraintUpdate<ConstraintEdgesReference>:
            return eRef.updateConstraintIfNeeded()
        case let dRef as ConstraintUpdate<ConstraintDimensionReference>:
            return dRef.updateConstraintIfNeeded()
        case let cRef as ConstraintUpdate<ConstraintCenterReference>:
            return cRef.updateConstraintIfNeeded()
        default:
            fatalError()
        }
    }
}
