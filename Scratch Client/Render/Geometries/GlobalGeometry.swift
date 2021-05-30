//
//  GlobalGeometry.swift
//  Scratch Client
//
//  Created by Teddy Gaillard on 5/29/21.
//

import Foundation
import Metal
import simd

protocol GlobalGeometry: Geometry {
	var modelToWorld: simd_float4x4 { get }
}

extension GlobalGeometry {
	func generateMatrixBuffer() -> MTLBuffer? {
		guard let device = MTLCreateSystemDefaultDevice() else { return nil }
		var mutableMatrix = self.modelToWorld
		return device.makeBuffer(
			bytes: &mutableMatrix,
			length: MemoryLayout<simd_float4x4>.size
		)
	}
}
