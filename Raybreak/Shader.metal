//
//  Shader.metal
//  Raybreak
//
//  Created by shaund on 2020/4/5.
//  Copyright © 2020 demo. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

//这里面用的是C++ (metal shading language)

struct Constants { //定义这个struct，好让vertex函数能识别
    float animateBy;
};

struct VertexIn {
    float4 position [[attribute(0)]];
    float4 color [[attribute(1)]];
};

struct VertexOut {
    float4 position [[position]];
    float4 color;
};

/// 这是一个顶点函数，返回值是float4
vertex VertexOut vertex_shader(const VertexIn vertexIn[[stage_in]]) {
    //return float4(vertices[vertexId], 1);
    
//    float4 position = float4(vertices[vertexId], 1);
//    position.x += constants.animateBy;
//    return position;
    
    VertexOut vertexOut;
    vertexOut.position = vertexIn.position;
    vertexOut.color = vertexIn.color;
    return vertexOut;
}


/// 分段函数，返回值是half4
fragment half4 fragment_shader(VertexOut vertexIn[[stage_in]]) {
//    return half4(1, 1, 0, 1); // (red, blue, green, alpha), return a red color
    return half4(vertexIn.color);
}
