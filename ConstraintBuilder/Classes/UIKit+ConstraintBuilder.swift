//
//  UIKit+ConstraintBuilder.swift
//  ConstraintBuilder
//
//  Created by brennobemoura on 07/04/20.
//

import Foundation
import UIKit

public extension UIView {
    var cbuild: Constraintable {
        .init(self)
    }
}

public extension UILayoutGuide {
    var cbuild: Constraintable {
        .init(self)
    }
}
