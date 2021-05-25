//
//  BlockGeometry.swift
//  Scratch Client
//
//  Created by Teddy Gaillard on 5/24/21.
//

import Foundation
import simd

struct BlockGeometry: Geometry {
	private let faces: Array<BlockFaceGeometry>
	let renderedFaces: Set<CubeFace>
	let position: simd_float3
	let sideLength: Float
	let lightLevel: Float
	
	private static let lightingConstants: Dictionary<CubeFace, Float> = [
		.up: 1,
		.down: 1,
		.north: 0.7,
		.south: 0.7,
		.east: 0.4,
		.west: 0.4
	]
	
	init(faces: Set<CubeFace>, position: simd_float3, sideLength: Float, lightLevel: Float) {
		
		var temporaryFaces: Array<BlockFaceGeometry> = []
		for face in faces {
			temporaryFaces.append(BlockFaceGeometry(direction: face, position: position, sideLength: sideLength, lightLevel: BlockGeometry.lightingConstants[face]!))
		}
		
		self.renderedFaces = faces
		self.faces = temporaryFaces
		self.position = position
		self.sideLength = sideLength
		self.lightLevel = lightLevel
	}
	
	var vertices: Array<Vertex> {
		return self.faces.reduce([]) { $0 + $1.vertices }
	}
}
