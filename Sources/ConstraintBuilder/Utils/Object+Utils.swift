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

extension CBObject {
    func isUIEqual(to object: AnyObject?) -> Bool {
        if let view = self as? CBView {
            if let guide = object as? CBLayoutGuide {
                return view === guide.owningView
            }
        }

        if let guide = self as? CBLayoutGuide {
            if let view = object as? CBView {
                return guide.owningView === view
            }
        }

        return self === object
    }
}

extension CBObject {
    var uiSuperitem: CBObject? {
        switch self {
        case let view as CBView:
            return view.superview
        case let guide as CBLayoutGuide:
            return guide.owningView?.superview
        default:
            fatalError()
        }
    }

    var uiConstraints: [CBLayoutConstraint] {
        switch self {
        case let view as CBView:
            return view.constraints
        case let guide as CBLayoutGuide:
            return guide.owningView?.constraints.filter {
                $0.firstItem === guide || $0.secondItem === guide
            } ?? []
        default:
            fatalError()
        }
    }
}
