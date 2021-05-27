//
//  MetalViewWrapper.swift
//  Scratch Client
//
//  Created by Teddy Gaillard on 5/25/21.
//

import Foundation
import MetalKit

class MetalViewWrapper: MTKView {
	override func keyDown(with event: NSEvent) {
		switch event.keyCode {
		case 126:
			(self.delegate as? RenderWrapper)?.renderer.camera.pitch += Float.pi / 8
		case 125:
			(self.delegate as? RenderWrapper)?.renderer.camera.pitch -= Float.pi / 8
		case 124:
			(self.delegate as? RenderWrapper)?.renderer.camera.yaw += Float.pi / 8
		case 123:
			(self.delegate as? RenderWrapper)?.renderer.camera.yaw -= Float.pi / 8
		default:
			print(event.keyCode)
		}
	}
	override var acceptsFirstResponder: Bool {
		return true
	}
}
