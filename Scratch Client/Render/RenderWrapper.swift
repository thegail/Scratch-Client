//
//  RenderWrapper.swift
//  Scratch Client
//
//  Created by Teddy Gaillard on 5/22/21.
//

import Foundation
import MetalKit

class RenderWrapper: NSObject, MTKViewDelegate {
	
	let renderer: WorldRenderer
	
	override init() {
		self.renderer = WorldRenderer()
	}
	
	func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
		
	}
	
	func draw(in view: MTKView) {
		self.renderer.draw(in: view)
	}
	
}
