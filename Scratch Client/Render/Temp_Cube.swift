//
//  Temp_Cube.swift
//  Scratch Client
//
//  Created by Teddy Gaillard on 5/22/21.
//

import Foundation
import simd

struct Cube {
	
	private static let lightLevels: Dictionary<CubeFace, Float> = [
		.north: 0.3,
		.south: 0.3,
		.east: 0.6,
		.west: 0.6,
		.up: 1,
		.down: 1
	]
	
	private static let neg: Float = -0.275
	private static let pos: Float = 0.275
	
	static let vertices: Array<simd_float3> = [
		simd_float3(neg, neg, neg),
		simd_float3(neg, neg, pos),
		simd_float3(neg, pos, neg),
		simd_float3(neg, pos, pos),
		simd_float3(pos, neg, neg),
		simd_float3(pos, neg, pos),
		simd_float3(pos, pos, neg),
		simd_float3(pos, pos, pos)
	]
	
	let renderedFaces: Array<CubeFace>
	
	var vertices: Array<Vertex> {
		var indices: Array<UInt16> = []
		var finalVertcies: Array<Vertex> = []
		var faces: Array<CubeFace> = []
		for face in renderedFaces {
			switch face {
			case .up:
				indices += [2, 3, 7, 2, 6, 7]
			case .down:
				indices += [0, 1, 5, 0, 4, 5]
			case .north:
				indices += [5, 1, 3, 5, 7, 3]
			case .south:
				indices += [4, 0, 2, 4, 6, 2]
			case .east:
				indices += [4, 5, 7, 4, 6, 7]
			case .west:
				indices += [0, 1, 3, 0, 2, 3]
			}
			faces += Array<CubeFace>(repeating: face, count: 6)
		}
		for (index, face) in zip(indices, faces) {
			finalVertcies.append(Vertex(position: Cube.vertices[Int(index)], lightLevel: Cube.lightLevels[face]!))
		}
		return finalVertcies
	}
}

