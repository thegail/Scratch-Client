//
//  Matrix.swift
//  Scratch Client
//
//  Created by Teddy Gaillard on 5/22/21.
//

import Foundation
import simd

struct Matrix {
	
	static func rotation(x: Float) -> simd_float4x4 {
		var matrix = simd_float4x4(1)
		matrix.columns.1 = [0, cos(x), sin(x), 0]
		matrix.columns.2 = [0, -sin(x), cos(x), 0]
		return matrix
	}
	
	static func rotation(y: Float) -> simd_float4x4 {
		var matrix = simd_float4x4(1)
		matrix.columns.0 = [cos(y), 0, -sin(y), 0]
		matrix.columns.2 = [sin(y), 0, cos(y), 0]
		return matrix
	}
	
	static func rotation(x: Float, y: Float) -> simd_float4x4 {
		return Matrix.rotation(x: x) * Matrix.rotation(y: y)
	}
}
