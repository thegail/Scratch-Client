//
//  DrawError.swift
//  Scratch Client
//
//  Created by Teddy Gaillard on 5/28/21.
//

import Foundation

enum DrawError: Error {
	case failedToCreateBuffer(type: BufferType)
	case failedToCreateRenderEncoder
	case failedToCreateRenderPassDescriptor
}
