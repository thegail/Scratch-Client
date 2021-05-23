//
//  Temp_Cube.swift
//  Scratch Client
//
//  Created by Teddy Gaillard on 5/22/21.
//

import Foundation
import simd

struct Cube {
	
	private static let neg: Float = -0.275
	private static let pos: Float = 0.275
	
	static let vertices: Array<Vertex> = [
		Vertex(position: simd_float3(neg, neg, neg)),
		Vertex(position: simd_float3(neg, neg, pos)),
		Vertex(position: simd_float3(neg, pos, neg)),
		Vertex(position: simd_float3(neg, pos, pos)),
		Vertex(position: simd_float3(pos, neg, neg)),
		Vertex(position: simd_float3(pos, neg, pos)),
		Vertex(position: simd_float3(pos, pos, neg)),
		Vertex(position: simd_float3(pos, pos, pos))
	]
	
	let renderedFaces: Array<CubeFace>
	
	var vertices: Array<Vertex> {
		var indices: Array<UInt16> = []
		var finalVertcies: Array<Vertex> = []
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
		}
		for index in indices {
			finalVertcies.append(Cube.vertices[Int(index)])
		}
		return finalVertcies
	}
}

