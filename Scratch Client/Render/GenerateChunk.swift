//
//  GenerateChunk.swift
//  Scratch Client
//
//  Created by Teddy Gaillard on 5/29/21.
//

import Foundation

func generateChunk(size: Int) -> Array<Array<Array<Bool>>> {
	var final: Array<Array<Array<Bool>>> = []
	for yCoordinate in 0..<size {
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
