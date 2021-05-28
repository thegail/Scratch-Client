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
		do {
			self.renderer = try WorldRenderer()
		} catch RendererInitializationError.failedToGetDevice {
			fatalError("Failed to initialize renderer: failed to get device. This error should never appear")
		} catch RendererInitializationError.failedToCreateCommandQueue {
			fatalError("Failed to initialize renderer: failed to create command queue")
		} catch RendererInitializationError.failedToCreateShader(type: let type) {
			// swiftlint:disable:next line_length
			fatalError("Failed to initialize renderer: failed to create \(type.rawValue) shader. Check that your shader file contains a \(type.rawValue) function")
		} catch {
			fatalError("Failed to initialize renderer")
		}
	}
	
	func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
		
	}
	
	func draw(in view: MTKView) {
		do {
			try self.renderer.draw(in: view)
		} catch DrawError.failedToCreateBuffer(type: let type) {
			fatalError("Failed to render frame: failed to create \(type) buffer")
		} catch {
			fatalError("Failed to render frame")
		}
	}
	
}
