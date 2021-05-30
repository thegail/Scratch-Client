//
//  Geometry.swift
//  Scratch Client
//
//  Created by Teddy Gaillard on 5/22/21.
//

import Foundation
import Metal

protocol Geometry {
	var vertices: Array<Vertex> { get }
}

extension Geometry {
	func generateVertexBuffer() -> MTLBuffer? {
		guard let device = MTLCreateSystemDefaultDevice() else { return nil }
		return device.makeBuffer(
			bytes: self.vertices,
			length: self.vertices.count * MemoryLayout<Vertex>.stride,
			options: [.storageModeShared]
		)
	}
}
