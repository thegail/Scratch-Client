//
//  shaders.metal
//  Scratch Client
//
//  Created by Teddy Gaillard on 5/22/21.
//

#include <metal_stdlib>
using namespace metal;

struct Vertex {
	float3 pos;
	float ltl;
};

struct RasterizerData {
	float4 pos [[position]];
	float ltl;
};

vertex RasterizerData sc_vertex_shader(constant Vertex* vertices [[buffer(0)]], uint vid [[vertex_id]], constant float4x4 &rm [[buffer(1)]]) {
	Vertex in = vertices[vid];
	RasterizerData out;
	
	out.pos = float4(in.pos, 1) * rm;
	out.pos.z = out.pos.z + 0.469;
	
	out.ltl = in.ltl;
	return out;
}

fragment float4 sc_fragment_shader(RasterizerData in [[stage_in]]) {
	return float4(float3(1) * in.ltl, 1);
}
