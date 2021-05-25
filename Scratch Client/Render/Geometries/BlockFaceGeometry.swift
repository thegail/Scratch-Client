//
//  BlockFaceGeometry.swift
//  Scratch Client
//
//  Created by Teddy Gaillard on 5/24/21.
//

import Foundation
import simd

struct BlockFaceGeometry: Geometry {
	let direction: CubeFace
	let position: simd_float3
	let sideLength: Float
	
	let lightLevel: Float
	
	var vertices: Array<Vertex> {
		let neg = -sideLength/2
		let pos = sideLength/2
		
		var finalIndices: Array<UInt> = []
		
		let indices = [
			position + simd_float3(neg, neg, neg),
			position + simd_float3(neg, neg, pos),
			position + simd_float3(neg, pos, neg),
			position + simd_float3(neg, pos, pos),
			position + simd_float3(pos, neg, neg),
			position + simd_float3(pos, neg, pos),
			position + simd_float3(pos, pos, neg),
			position + simd_float3(pos, pos, pos)
		]
		
		switch self.direction {
		case .up:
			finalIndices += [2, 3, 7, 2, 6, 7]
		case .down:
			finalIndices += [0, 1, 5, 0, 4, 5]
		case .north:
			finalIndices += [5, 1, 3, 5, 7, 3]
		case .south:
			finalIndices += [4, 0, 2, 4, 6, 2]
		case .east:
			finalIndices += [4, 5, 7, 4, 6, 7]
		case .west:
			finalIndices += [0, 1, 3, 0, 2, 3]
		}
		
		var finalVertices: Array<Vertex> = []
		
		for index in finalIndices {
			finalVertices.append(Vertex(position: indices[Int(index)], lightLevel: self.lightLevel))
		}
		return finalVertices
	}
}
