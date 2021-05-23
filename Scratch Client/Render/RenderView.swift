//
//  RenderView.swift
//  Scratch Client
//
//  Created by Teddy Gaillard on 5/22/21.
//

import Foundation
import SwiftUI
import MetalKit

struct RenderView: NSViewRepresentable {
	
	let fps: Int = 60
	
	func makeCoordinator() -> RenderWrapper {
		return RenderWrapper()
	}
	
	func makeNSView(context: Context) -> some NSView {
		let metalView = MTKView()
		metalView.delegate = context.coordinator
		metalView.preferredFramesPerSecond = self.fps
		let device = MTLCreateSystemDefaultDevice()
		if device == nil {
			// @TODO handle
			fatalError("Device doesn't support metal")
		}
		metalView.device = device
		metalView.framebufferOnly = true
		metalView.clearColor = MTLClearColor(red: 0, green: 1, blue: 0, alpha: 1)
		metalView.drawableSize = metalView.frame.size
		return metalView
	}
	
	func updateNSView(_ nsView: NSViewType, context: Context) {
		
	}
}
