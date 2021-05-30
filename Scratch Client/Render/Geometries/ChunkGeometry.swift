//
//  ChunkGeometry.swift
//  Scratch Client
//
//  Created by Teddy Gaillard on 5/29/21.
//

import Foundation
import simd

struct ChunkGeometry: GlobalGeometry {
	
	let height: UInt
	let width: UInt
	let depth: UInt
	let dimensions: simd_float3
	let position: simd_float3
	
	private var blocks: Array<Array<Array<BlockGeometry?>>>
	private(set) var vertices: Array<Vertex>
	
	init?(
		height: UInt,
		width: UInt,
		depth: UInt,
		dimensions: simd_float3,
		position: simd_float3,
		blocks: Array<Array<Array<Bool>>>
	) {
		
		self.height = height
		self.width = width
		self.depth = depth
		self.dimensions = dimensions
		self.position = position
		
		let sideLength = dimensions.y / Float(height)
		
		if dimensions.x / Float(width) != sideLength || dimensions.z / Float(depth) != sideLength {
			return nil
		}
		
		if blocks.count != height {
			return nil
		}
		
		self.blocks = []
		
		for (yCoordinate, layer) in blocks.enumerated() {
			if layer.count != width {
				return nil
			}
			self.blocks.append([])
			for (xCoordinate, strip) in layer.enumerated() {
				if strip.count != depth {
					return nil
				}
				self.blocks[yCoordinate].append([])
				for (zCoordinate, blockExists) in strip.enumerated() {
					if blockExists {
						self.blocks[yCoordinate][xCoordinate].append(BlockGeometry(
							faces: ChunkGeometry.getRenderedFaces(for: (xCoordinate, yCoordinate, zCoordinate), blocks: blocks),
							position: simd_float3(
								Float(xCoordinate) * sideLength,
								Float(yCoordinate) * sideLength,
								Float(zCoordinate) * sideLength
							),
							sideLength: sideLength,
							lightLevel: 1
						))
					} else {
						self.blocks[yCoordinate][xCoordinate].append(nil)
					}
				}
			}
		}
		
		self.vertices = []
		for layer in self.blocks {
			for strip in layer {
				for block in strip where block != nil {
					self.vertices.append(contentsOf: block!.vertices)
				}
			}
		}
	}
	
	private static func getRenderedFaces(
		for position: (x: Int, y: Int, z: Int),
		blocks: Array<Array<Array<Bool>>>
	) -> Set<CubeFace> {
		var coveredFaces: Set<CubeFace> = []
		for yOff in [-1, 1] {
			if blocks.indices.contains(position.y + yOff) {
				if blocks[position.y + yOff][position.x][position.z] {
					coveredFaces.insert(yOff == 1 ? .up : .down)
				}
			}
		}
		for xOff in [-1, 1] {
			if blocks[0].indices.contains(position.x + xOff) {
				if blocks[position.y][position.x + xOff][position.z] {
					coveredFaces.insert(xOff == 1 ? .east : .west)
				}
			}
		}
		for zOff in [-1, 1] {
			if blocks[0][0].indices.contains(position.z + zOff) {
				if blocks[position.y][position.x][position.z + zOff] {
					coveredFaces.insert(zOff == 1 ? .north : .south)
				}
			}
		}
		
		return CubeFace.all.subtracting(coveredFaces)
	}
	
	var modelToWorld: simd_float4x4 {
		return Matrix.translation(-self.position)
	}
}
