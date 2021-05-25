//
//  Camera.swift
//  Scratch Client
//
//  Created by Teddy Gaillard on 5/24/21.
//

import Foundation
import simd

struct Camera {
	let position: simd_float3
	let pitch: Float
	let yaw: Float
	let fov: Float
	
	var worldToClipMatrix: simd_float4x4 {
		let worldToViewMatrix = Matrix.rotations(x: self.pitch, y: self.yaw)
		let viewToClipMatrix = Matrix.projection(fov: self.fov)
		return worldToViewMatrix * viewToClipMatrix
	}
}
