//
//  Shader.metal
//  Raybreak
//
//  Created by shaund on 2020/4/5.
//  Copyright © 2020 demo. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

//这里面用的是C++

struct Constants { //定义这个struct，好让vertex函数能识别
    float animateBy;
};

/// 这是一个顶点函数，返回值是float4
vertex float4 vertex_shader(const device packed_float3 * vertices[[buffer(0)]],
                            constant Constants &constants[[buffer(1)]],
                            uint vertexId [[vertex_id]]) {
    //return float4(vertices[vertexId], 1);
    
    float4 position = float4(vertices[vertexId], 1);
    position.x += constants.animateBy;
    return position;
}


/// 分段函数，返回值是half4
fragment half4 fragment_shader() {
    return half4(1, 1, 0, 1); // (red, blue, green, alpha), return a red color
}
