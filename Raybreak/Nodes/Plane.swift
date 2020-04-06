//
//  Plane.swift
//  Raybreak
//
//  Created by shaund on 2020/4/6.
//  Copyright © 2020 demo. All rights reserved.
//

import MetalKit


class Plane: Node {
//    var vertices: [Float] = [
//        -1, 1, 0,   //V0
//        -1, -1, 0,  //V1
//        1, -1, 0,   //V2
//        1, 1, 0     //V3
//    ]
    var vertices: [Vertex] = [
        //携带颜色的顶点数据
        Vertex(position: SIMD3<Float>(-1, 1, 0), color: SIMD4<Float>(1, 0, 0, 1)), //V0
        Vertex(position: SIMD3<Float>(-1, -1, 0), color: SIMD4<Float>(0, 1, 0, 1)), //V1
        Vertex(position: SIMD3<Float>(1, -1, 0), color: SIMD4<Float>(0, 0, 1, 1)), //V2
        Vertex(position: SIMD3<Float>(1, 1, 0), color: SIMD4<Float>(1, 0, 1, 1)), //V3
    ]
    var indices: [UInt16] = [
        //随着图形的增多，有很多重复的顶点，就涉及很多重复的工作为了减少顶点的传入（传给GPU），
        //我们用索引矩阵。这里的索引矩阵描述了2个三角形和它们的绘制顺序。
        0, 1, 2,
        2, 3, 0
    ]
    
    var vertexBuffer: MTLBuffer?
    var indexBuffer: MTLBuffer?
    
    struct Constants {
        var animateBy: Float = 0
    }
    var constants = Constants()
    var time: Float = 0 // how long the app's been running

    init(device: MTLDevice) {
        super.init()
        buildBuffers(device: device)
    }
    
    private func buildBuffers(device: MTLDevice) {
        vertexBuffer = device.makeBuffer(bytes: vertices,
                                         length: vertices.count * MemoryLayout<Vertex>.stride,
                                         options: [])
        indexBuffer = device.makeBuffer(bytes: indices,
                                        length: indices.count * MemoryLayout<UInt16>.size,
                                        options: [])
    }
}
