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

extension NSLayoutConstraint.Attribute {
    func isEqual(to attribute: NSLayoutConstraint.Attribute) -> Bool {
        switch self {
        case .leading, .left:
            return [.leading, .left].contains(attribute)
        case .leadingMargin, .leftMargin:
            return [.leadingMargin, .leftMargin].contains(attribute)
        case .trailing, .right:
            return [.trailing, .right].contains(attribute)
        case .trailingMargin, .rightMargin:
            return [.trailingMargin, .rightMargin].contains(attribute)
        default:
            return self == attribute
        }
    }
}

extension NSLayoutConstraint.Attribute {
    var isValid: Bool {
        switch self {
        case .top, .topMargin, .bottom, .bottomMargin, .leading, .leadingMargin, .trailing, .trailingMargin, .left, .leftMargin, .right, .rightMargin, .lastBaseline, .firstBaseline, .centerX, .centerXWithinMargins, .centerY, .centerYWithinMargins, .height, .width, .notAnAttribute:
            return true
        @unknown default:
            return false
        }
    }
}

extension NSLayoutConstraint.Attribute {
    var isNegative: Bool {
        switch self {
        case .bottom, .bottomMargin, .trailing, .trailingMargin, .right, .rightMargin:
            return true
        case .centerY, .centerYWithinMargins, .lastBaseline:
            return true
        default:
            return false
        }
    }

    func needsItem(_ firstItem: NSObject) -> NSObject? {
        switch self {
        case .top, .topMargin, .bottom, .bottomMargin:
            return firstItem.uiSuperitem
        case .leading, .leadingMargin, .trailing, .trailingMargin:
            return firstItem.uiSuperitem
        case .left, .leftMargin, .right, .rightMargin:
            return firstItem.uiSuperitem
        case .lastBaseline, .firstBaseline:
            return firstItem.uiSuperitem
        case .centerX, .centerXWithinMargins, .centerY, .centerYWithinMargins:
            return firstItem.uiSuperitem
        case .height, .width, .notAnAttribute:
            return nil
        @unknown default:
            return nil
        }
    }
}
