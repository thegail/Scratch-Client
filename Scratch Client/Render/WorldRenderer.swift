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
	var renderedModels: Array<GlobalGeometry>
	var camera: Camera
	
	init() throws {
		guard let device = MTLCreateSystemDefaultDevice() else { throw RendererInitializationError.failedToGetDevice }
		guard let temporaryCommandQueue = device.makeCommandQueue() else {
			throw RendererInitializationError.failedToCreateCommandQueue
		}
		self.commandQueue = temporaryCommandQueue
		
		self.camera = Camera(position: simd_float3(0.1, 1.1, -0.3), pitch: 0, yaw: 0, fov: Float.pi / 2)
		
		let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
		
		guard let library = device.makeDefaultLibrary() else { fatalError("Failed to create shader library") }
		guard let vertexShader = library.makeFunction(name: "sc_vertex_shader") else {
			throw RendererInitializationError.failedToCreateShader(type: .vertex)
		}
		guard let fragmentShader = library.makeFunction(name: "sc_fragment_shader") else {
			throw RendererInitializationError.failedToCreateShader(type: .fragment)
		}
		
		pipelineStateDescriptor.vertexFunction = vertexShader
		pipelineStateDescriptor.fragmentFunction = fragmentShader
		pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
		pipelineStateDescriptor.depthAttachmentPixelFormat = .depth32Float
		
		do {
			self.pipelineState = try device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
		} catch {
			fatalError("Failed to create render pipeline state. This message should never appear")
		}
		
		self.renderedModels = [
			ChunkGeometry(
				height: UInt(256),
				width: UInt(16),
				depth: UInt(16),
				dimensions: simd_float3(0.0625, 1, 0.0625),
				position: simd_float3(0, 0, 0),
				blocks: generateChunk()
			)!,
			ChunkGeometry(
				height: UInt(256),
				width: UInt(16),
				depth: UInt(16),
				dimensions: simd_float3(0.0625, 1, 0.0625),
				position: simd_float3(0.0625, 0, 0),
				blocks: generateChunk()
			)!
		]
	}
	
	func draw(in view: MTKView) throws {
		guard let commandBuffer = self.commandQueue.makeCommandBuffer() else { return }
		guard let renderPassDescriptor = view.currentRenderPassDescriptor else { return }
		
		renderPassDescriptor.colorAttachments[0].clearColor = view.clearColor
		
		guard let renderPassEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return }
		
		var worldToClipMatrix = self.camera.worldToClipMatrix
		
		let matrixSize = MemoryLayout<simd_float4x4>.size
		guard let worldToClipMatrixBuffer = view.device?.makeBuffer(bytes: &worldToClipMatrix, length: matrixSize) else {
			throw DrawError.failedToCreateBuffer(type: .matrix)
		}
		
		let depthDescriptor = MTLDepthStencilDescriptor()
		depthDescriptor.depthCompareFunction = .lessEqual
		depthDescriptor.isDepthWriteEnabled = true
		guard let depthState = view.device?.makeDepthStencilState(descriptor: depthDescriptor) else { return }
		
		renderPassEncoder.setRenderPipelineState(self.pipelineState)
		renderPassEncoder.setDepthStencilState(depthState)
		
		
		for renderedModel in self.renderedModels {
			guard let vertexBuffer = renderedModel.generateVertexBuffer() else {
				throw DrawError.failedToCreateBuffer(type: .vertex)
			}
			guard let modelToWorldMatrixBuffer = renderedModel.generateMatrixBuffer() else {
				throw DrawError.failedToCreateBuffer(type: .matrix)
			}
			renderPassEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
			renderPassEncoder.setVertexBuffer(worldToClipMatrixBuffer, offset: 0, index: 1)
			renderPassEncoder.setVertexBuffer(modelToWorldMatrixBuffer, offset: 0, index: 2)
			renderPassEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: renderedModel.vertices.count)
		}
		
		renderPassEncoder.endEncoding()
		
		commandBuffer.present(view.currentDrawable!)
		commandBuffer.commit()
	}
	
}
