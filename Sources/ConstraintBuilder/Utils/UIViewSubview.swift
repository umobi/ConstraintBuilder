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
#if os(macOS)
import AppKit
#else
import UIKit
#endif

/// UICSubview class is a wrapper that will add the subview into superview, but checking the `translatesAutoresizingMaskIntoConstraints` and set to false if is needed
public extension CBView {
    struct CBSubview<Super: CBView> {
        fileprivate weak var superview: Super!

        /// Safety check superview and set `translatesAutoresizingMaskIntoConstraints` to false if needed
        public init(_ superview: Super) {
            self.superview = superview
            self.spSafe()
        }

        /// Safety check superview and set `translatesAutoresizingMaskIntoConstraints` to false if needed
        public init?(_ superview: Super?) {
            guard let superview = superview else {
                return nil
            }

            self.superview = superview
            self.spSafe()
        }

        private func spSafe() {
            self.superview.setAutoresizingToFalse(.superview)
        }
    }

    fileprivate enum SubviewMode {
        case superview
        case subview
    }
}

public extension CBView.CBSubview {
    /// Performs `addSubview(_:)` on `CBView`
    func addSubview(_ view: CBView) {
        self.safe(view)
        self.superview.addSubview(view)
    }

    /// Performs `insertSubview(_:, at:)` on `CBView`
    func insertSubview(_ view: CBView, at index: Int) {
        self.safe(view)

        #if !os(macOS)
        self.superview.insertSubview(view, at: index)
        #else
        guard let relativeView = self.superview.subviews.enumerated().first(where: { $0.offset == index })?.element else {
            if let lastView = self.superview.subviews.last {
                self.superview.addSubview(view, positioned: .above, relativeTo: lastView)
            } else {
                self.superview.addSubview(view)
            }
            return
        }
        self.superview.addSubview(view, positioned: .below, relativeTo: relativeView)
        #endif
    }

    /// Performs `insertSubview(_:, aboveSubview:)` on `CBView`
    func insertSubview(_ view: CBView, aboveSubview subview: CBView) {
        self.safe(view)
        #if !os(macOS)
        self.superview.insertSubview(view, aboveSubview: subview)
        #else
        self.superview.addSubview(view, positioned: .above, relativeTo: subview)
        #endif
    }

    /// Performs `insertSubview(_:, belowSubview:)` on `CBView`
    func insertSubview(_ view: CBView, belowSubview subview: CBView) {
        self.safe(view)
        #if !os(macOS)
        self.superview.insertSubview(view, belowSubview: subview)
        #else
        self.superview.addSubview(view, positioned: .below, relativeTo: subview)
        #endif
    }
}

public extension CBView.CBSubview where Super: CBStackView {
    /// Performs `addArrangedSubview(_:)` on `UIStackView`
    func addArrangedSubview(_ view: CBView!) {
        self.safe(view)
        self.superview.addArrangedSubview(view)
    }

    /// Performs `insertArrangedSubview(_:, at:)` on `UIStackView`
    func insertArrangedSubview(_ view: CBView, at index: Int) {
        self.safe(view)
        self.superview.insertArrangedSubview(view, at: index)
    }
}

private extension CBView.CBSubview {
    func safe(_ view: CBView) {
        view.setAutoresizingToFalse(.subview)
        if view === self.superview {
            fatalError()
        }
    }
}

private extension CBView {
    func setAutoresizingToFalse(_ mode: SubviewMode) {
        if case .superview = mode {
            switch self.next {
            case is CBViewController:
                return
            case is CBVisualEffectView:
                return
            #if !os(macOS)
            case is UITableViewCell:
                return
            case is UICollectionViewCell:
                return
            case is UITableViewHeaderFooterView:
                return
            case is UICollectionReusableView:
                return
            #endif
            default:
                break
            }

            #if os(macOS)
            guard !((self as NSResponder) is CBWindow) else {
                return
            }
            #else
            guard !(self is CBWindow) else {
                return
            }
            #endif

        }

        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
