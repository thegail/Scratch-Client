//
//  GenerateChunk.swift
//  Scratch Client
//
//  Created by Teddy Gaillard on 5/29/21.
//

import Foundation

func generateChunk() -> Array<Array<Array<Bool>>> {
	var final: Array<Array<Array<Bool>>> = []
	let ySize = 256
	let size = 16
	for yCoordinate in 0..<ySize {
		final.append([])
		for xCoordinate in 0..<size {
			final[yCoordinate].append([])
			for zCoordinate in 0..<size {
				final[yCoordinate][xCoordinate].append(!(xCoordinate == 0 && zCoordinate == 0))
			}
		}
	}
	return final
}
