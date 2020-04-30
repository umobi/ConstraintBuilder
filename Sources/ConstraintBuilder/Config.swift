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

public typealias CBObject = NSObject
public typealias CBLayoutConstraint = NSLayoutConstraint

#if os(macOS)
public typealias CBView = NSView
public typealias CBLayoutGuide = NSLayoutGuide
public typealias CBLayoutPriority = NSLayoutConstraint.Priority
public typealias CBStackView = NSStackView
public typealias CBWindow = NSWindow
public typealias CBViewController = NSViewController
public typealias CBVisualEffectView = NSVisualEffectView
#else
public typealias CBView = UIView
public typealias CBLayoutGuide = UILayoutGuide
public typealias CBLayoutPriority = UILayoutPriority
public typealias CBStackView = UIStackView
public typealias CBWindow = UIWindow
public typealias CBViewController = UIViewController
public typealias CBVisualEffectView = UIVisualEffectView
#endif

#if os(macOS)
extension CBView {
    var next: NSResponder? {
        self.nextResponder
    }
}
#endif
