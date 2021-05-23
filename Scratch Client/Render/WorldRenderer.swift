//
//  WorldRenderer.swift
//  Scratch Client
//
//  Created by Teddy Gaillard on 5/22/21.
//

import Foundation
import MetalKit

class WorldRenderer {
	
	let commandQueue: MTLCommandQueue
	let pipelineState: MTLRenderPipelineState
	var renderedModel: Model
	
	init() {
		guard let device = MTLCreateSystemDefaultDevice() else { fatalError("Failed to get render view's device attribute. This is an issue with the way class WorldRenderer is initialized, and this message should never appear.") }
		guard let temporaryCommandQueue = device.makeCommandQueue() else { fatalError("Failed to create rendering command queue.") }
		self.commandQueue = temporaryCommandQueue
		
		
		let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
		
		guard let library = device.makeDefaultLibrary() else { fatalError("Failed to create shader library") }
		guard let vertexShader = library.makeFunction(name: "sc_vertex_shader") else { fatalError("Failed to create vertex shader. Check that your shader file contains a vertex function named sc_vertex_shader") }
		guard let fragmentShader = library.makeFunction(name: "sc_fragment_shader") else { fatalError("Failed to create fragment shader. Check that your shader file contains a fragment function named sc_fragment_shader") }
		
		pipelineStateDescriptor.vertexFunction = vertexShader
		pipelineStateDescriptor.fragmentFunction = fragmentShader
		pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
		pipelineStateDescriptor.depthAttachmentPixelFormat = .depth32Float
		
		do {
			self.pipelineState = try device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
		} catch {
			fatalError("Failed to create render pipeline state. This message should never appear")
		}
		
		self.renderedModel = MiniChunk(height: 2, width: 2, depth: 2, state: [
			[
				[true, false],
				[true, true]
			],
			[
				[true, false],
				[true, true]
			]
		])!
	}
	
	func draw(in view: MTKView) {
		guard let commandBuffer = self.commandQueue.makeCommandBuffer() else { return }
		guard let renderPassDescriptor = view.currentRenderPassDescriptor else { return }
		
		renderPassDescriptor.colorAttachments[0].clearColor = view.clearColor
		
		guard let renderPassEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return }
		
		var rotationMatrix = Matrix.rotation(x: Float.pi / 4, y: Float.pi / 4)
		
		guard let vertexBuffer = view.device?.makeBuffer(bytes: self.renderedModel.vertices, length: self.renderedModel.vertices.count * MemoryLayout<Vertex>.stride) else { fatalError("Failed to create vertex buffer") }
		guard let matrixBuffer = view.device?.makeBuffer(bytes: &rotationMatrix, length: MemoryLayout<simd_float4x4>.size) else { fatalError("Failed to create matrix buffer") }
		
		let depthDescriptor = MTLDepthStencilDescriptor()
		depthDescriptor.depthCompareFunction = .lessEqual
		depthDescriptor.isDepthWriteEnabled = true
		guard let depthState = view.device?.makeDepthStencilState(descriptor: depthDescriptor) else { return }
		
		renderPassEncoder.setRenderPipelineState(self.pipelineState)
		renderPassEncoder.setDepthStencilState(depthState)
		
		renderPassEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
		renderPassEncoder.setVertexBuffer(matrixBuffer, offset: 0, index: 1)
		renderPassEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: self.renderedModel.vertices.count)
		
		renderPassEncoder.endEncoding()
		
		commandBuffer.present(view.currentDrawable!)
		commandBuffer.commit()
	}
	
}
