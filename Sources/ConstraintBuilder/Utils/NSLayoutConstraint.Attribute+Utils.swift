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

extension CBLayoutConstraint.Attribute {
    func isEqual(to attribute: CBLayoutConstraint.Attribute) -> Bool {
        switch self {
        case .leading, .left:
            return [.leading, .left].contains(attribute)
        case .trailing, .right:
            return [.trailing, .right].contains(attribute)
        #if !os(macOS)
        case .leadingMargin, .leftMargin:
            return [.leadingMargin, .leftMargin].contains(attribute)
        case .trailingMargin, .rightMargin:
            return [.trailingMargin, .rightMargin].contains(attribute)
        #endif
        default:
            return self == attribute
        }
    }
}

extension CBLayoutConstraint.Attribute {
    var isValid: Bool {
        switch self {
        case .top, .bottom,
             .leading, .trailing, .left, .right,
             .lastBaseline, .firstBaseline,
             .centerX, .centerY,
             .height, .width,
             .notAnAttribute:
            return true
        #if !os(macOS)
        case .topMargin, .bottomMargin,
             .leadingMargin, .trailingMargin, .leftMargin, .rightMargin,
             .centerXWithinMargins, .centerYWithinMargins:
            return true
        #endif
        @unknown default:
            return false
        }
    }
}

extension CBLayoutConstraint.Attribute {
    var isNegative: Bool {
        switch self {
        case .bottom, .trailing, .right, .centerY, .lastBaseline:
            return true

        #if !os(macOS)
        case .bottomMargin, .trailingMargin, .rightMargin, .centerYWithinMargins:
            return true
        #endif

        default:
            return false
        }
    }

    func needsItem(_ firstItem: CBObject) -> CBObject? {
        switch self {
        case .top, .leading, .bottom, .trailing, .left, .right, .lastBaseline, .firstBaseline, .centerX, .centerY:
            return firstItem.uiSuperitem

        #if !os(macOS)
        case .topMargin, .bottomMargin,
             .leadingMargin, .trailingMargin, .leftMargin, .rightMargin,
             .centerXWithinMargins, .centerYWithinMargins:
            return firstItem.uiSuperitem
        #endif

        case .height, .width, .notAnAttribute:
            return nil
        @unknown default:
            return nil
        }
    }
}
