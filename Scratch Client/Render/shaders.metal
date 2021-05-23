//
//  shaders.metal
//  Scratch Client
//
//  Created by Teddy Gaillard on 5/22/21.
//

#include <metal_stdlib>
using namespace metal;

vertex float4 sc_vertex_shader(constant float3* vertices [[buffer(0)]], uint vid [[vertex_id]]) {
	return float4(vertices[vid], 1);
}

fragment float4 sc_fragment_shader() {
	return float4(1);
}
