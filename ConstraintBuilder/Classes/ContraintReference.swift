//
//  ContraintReference.swift
//  ConstraintBuilder
//
//  Created by brennobemoura on 07/04/20.
//

import Foundation

public protocol ContraintReference {}

public struct ConstraintYReference: ContraintReference {}
public struct ConstraintXReference: ContraintReference {}
public struct ConstraintDimensionReference: ContraintReference {}
public struct ConstraintEdgesReference: ContraintReference {}
public struct ConstraintCenterReference: ContraintReference {}

public typealias ConstraintX = Constraint<ConstraintXReference>
public typealias ConstraintY = Constraint<ConstraintYReference>
public typealias ConstraintDimension = Constraint<ConstraintDimensionReference>
public typealias ConstraintEdges = Constraint<ConstraintEdgesReference>
public typealias ConstraintCenter = Constraint<ConstraintCenterReference>
