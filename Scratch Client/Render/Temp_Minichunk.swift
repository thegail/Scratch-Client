//
//  Temp_Minichunk.swift
//  Scratch Client
//
//  Created by Teddy Gaillard on 5/22/21.
//

import Foundation
import simd

struct MiniChunk: Model {
	let width: UInt
	let height: UInt
	let depth: UInt
	
	private var trueState: Array<Array<Array<Bool>>>
	var state: Array<Array<Array<Bool>>> {
		get {
			return self.trueState
		} set(newState) {
			if newState.count != height {
				return
			}
			for layer in newState {
				if layer.count != width {
					return
				}
				for strip in layer {
					if strip.count != depth {
						return
					}
				}
			}
			self.trueState = newState
		}
	}
	
	init?(height: UInt, width: UInt, depth: UInt, state initialState: Array<Array<Array<Bool>>>) {
		self.height = height
		self.width = width
		self.depth = depth
		self.trueState = []
		self.state = initialState
		if self.state == [] {
			return nil
		}
	}
	
	var vertices: Array<Vertex> {
		var finalVertices: Array<Vertex> = []
		let cubeDimension: Float = 0.415
		for y in 0..<height {
			for x in 0..<width {
				for z in 0..<depth {
					if self.state[Int(y)][Int(x)][Int(z)] {
						let cube = Cube(renderedFaces: [.down, .east, .north, .up, .west, .south])
						for vertex in cube.vertices {
							var currentVertex = vertex
							currentVertex.position.x /= Float(width)
							currentVertex.position.y /= Float(height)
							currentVertex.position.z /= Float(depth)
							
							currentVertex.position.x += Float(x) * cubeDimension / Float(width)
							currentVertex.position.y += Float(y) * cubeDimension / Float(height)
							currentVertex.position.z += Float(z) * cubeDimension / Float(depth)
							
							finalVertices.append(currentVertex)
						}
					}
				}
			}
		}
		return finalVertices
	}
}
