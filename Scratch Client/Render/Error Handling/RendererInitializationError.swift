//
//  RendererInitializationError.swift
//  Scratch Client
//
//  Created by Teddy Gaillard on 5/28/21.
//

import Foundation

enum RendererInitializationError: Error {
	case failedToGetDevice
	case failedToCreateCommandQueue
	case failedToCreateShaderLibrary
	case failedToCreateShader(type: ShaderType)
	case failedToCreatePipelineState
	case failedToCreateDepthState
}
