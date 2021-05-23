//
//  shaders.metal
//  Scratch Client
//
//  Created by Teddy Gaillard on 5/22/21.
//

#include <metal_stdlib>
using namespace metal;

vertex float4 sc_vertex_shader(constant float3* vertices [[buffer(0)]], uint vid [[vertex_id]], constant float4x4 &rm [[buffer(1)]]) {
	float3 in = vertices[vid];
	float4 out = float4(1);
	out.xyz = in;
	out = out * rm;
	out.z = out.z + 0.469;
	return out;
}

fragment float4 sc_fragment_shader() {
	return float4(1);
}
