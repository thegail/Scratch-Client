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
	
	static func rotation(z: Float) -> simd_float4x4 {
		var matrix = simd_float4x4(1)
		matrix.columns.0 = [cos(z), -sin(z), 0, 0]
		matrix.columns.1 = [sin(z), cos(z), 0, 0]
		return matrix
	}
	
	static func rotations(x: Float = 0, y: Float = 0, z: Float = 0) -> simd_float4x4 {
		return Matrix.rotation(x: x) * Matrix.rotation(y: y) * Matrix.rotation(z: z)
	}
	
	static func translation(_ translation: simd_float3) -> simd_float4x4 {
		var matrix = simd_float4x4(1)
		matrix.columns.0[3] = translation.x
		matrix.columns.0[3] = translation.y
		matrix.columns.0[3] = translation.z
		return matrix
	}
	
	static func scaling(factor: Float) -> simd_float4x4 {
		return scaling(vector: simd_float3(factor, factor, factor))
	}
	
	static func scaling(vector: simd_float3) -> simd_float4x4 {
		return simd_float4x4(diagonal: simd_float4(vector, 1))
	}
}
