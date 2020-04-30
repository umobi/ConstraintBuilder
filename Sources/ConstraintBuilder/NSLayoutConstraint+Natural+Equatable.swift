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

extension CBLayoutConstraint {
    enum ItemOrder {
        case firstFirst
        case secondFirst
        case firstSecond
        case secondSecond
        case none
    }

    private func isFirstItemEqual(_ natural: Natural) -> ItemOrder {
        if natural.firstItem.isUIEqual(to: self.firstItem) {
            return .firstFirst
        }

        if natural.firstItem.isUIEqual(to: self.secondItem) {
            return .firstSecond
        }

        if natural.secondItem?.isUIEqual(to: self.firstItem) ?? false {
            return .secondFirst
        }

        if natural.secondItem?.isUIEqual(to: self.secondItem) ?? false {
            return .secondSecond
        }

        return .none
    }

    private func isSecondItemEqual(_ natural: Natural, with order: ItemOrder) -> Bool {
        switch order {
        case .firstFirst:
            guard let secondItem = natural.secondItem else {
                return self.secondItem == nil
            }

            return secondItem.isUIEqual(to: self.secondItem)
        case .firstSecond:
            guard let secondItem = natural.secondItem else {
                return false
            }

            return secondItem.isUIEqual(to: self.firstItem)
        case .secondFirst:
            return natural.firstItem.isUIEqual(to: self.secondItem)
        case .secondSecond:
            return natural.firstItem.isUIEqual(to: self.firstItem)
        case .none:
            return false
        }
    }

    private func isFirstAttributeEqual(_ natural: Natural, with order: ItemOrder) -> Bool {
        switch order {
        case .firstFirst:
            return natural.firstAttribute.isEqual(to: self.firstAttribute)
        case .firstSecond:
            return natural.firstAttribute.isEqual(to: self.secondAttribute)
        case .secondFirst:
            guard let secondAttribute = natural.secondAttribute else {
                return self.firstAttribute == .notAnAttribute
            }

            return secondAttribute.isEqual(to: self.firstAttribute)
        case .secondSecond:
            guard let secondAttribute = natural.secondAttribute else {
                return self.secondAttribute == .notAnAttribute
            }

            return secondAttribute.isEqual(to: self.secondAttribute)
        case .none:
            return false
        }
    }

    private func isSecondAttributeEqual(_ natural: Natural, with order: ItemOrder) -> Bool {
        switch order {
        case .firstFirst:
            guard let secondAttribute = natural.secondAttribute else {
                return self.secondAttribute == .notAnAttribute
            }

            return secondAttribute.isEqual(to: self.secondAttribute)
        case .firstSecond:
            guard let secondAttribute = natural.secondAttribute else {
                return self.firstAttribute == .notAnAttribute
            }

            return secondAttribute.isEqual(to: self.firstAttribute)
        case .secondFirst:
            return natural.firstAttribute.isEqual(to: self.secondAttribute)
        case .secondSecond:
            return natural.firstAttribute.isEqual(to: self.firstAttribute)
        case .none:
            return false
        }
    }

    func isEqual(_ natural: Natural) -> Bool {
        let order = self.isFirstItemEqual(natural)

        if case .none = order {
            return false
        }

        guard self.isSecondItemEqual(natural, with: order) else {
            return false
        }

        guard self.isFirstAttributeEqual(natural, with: order) else {
            return false
        }

        guard self.isSecondItemEqual(natural, with: order) else {
            return false
        }

        if let relation = natural.relation, self.relation != relation {
            return false
        }

        if let priority = natural.priority, self.priority != priority {
            return false
        }

        if let constant = natural.constant, self.constant != constant {
            return false
        }

        if let multiplier = natural.multiplier, self.multiplier != multiplier {
            return false
        }

        return true
    }
}
