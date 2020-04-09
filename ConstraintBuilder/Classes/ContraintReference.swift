//
//  ContraintReference.swift
//  ConstraintBuilder
//
//  Created by brennobemoura on 07/04/20.
//

import Foundation

public protocol ConstraintReference {}

public struct ConstraintYReference: ConstraintReference {}
public struct ConstraintXReference: ConstraintReference {}
public struct ConstraintDimensionReference: ConstraintReference {}
public struct ConstraintEdgesReference: ConstraintReference {}
public struct ConstraintCenterReference: ConstraintReference {}

public typealias ConstraintX = Constraint<ConstraintXReference>
public typealias ConstraintY = Constraint<ConstraintYReference>
public typealias ConstraintDimension = Constraint<ConstraintDimensionReference>
public typealias ConstraintEdges = Constraint<ConstraintEdgesReference>
public typealias ConstraintCenter = Constraint<ConstraintCenterReference>
